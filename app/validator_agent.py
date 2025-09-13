"""
Validation Agent for detecting hallucinations and correcting extracted data

This module handles:
- Validating extracted data against original paper content
- Detecting hallucinations, misinterpretations, and missing data
- Applying corrections based on validation feedback
- Using the same LLM as extraction but with specialized validation prompts
"""

import json
import logging
from typing import Dict, Any, Optional, Tuple

from app.llm_interface import LLMInterface
from app.prompt_loader import prompt_loader
from app.config import Config


class ValidatorAgent:
    """Agent for validating and correcting extracted data to reduce hallucinations"""
    
    def __init__(self, llm_provider: str = None):
        self.logger = logging.getLogger(__name__)
        self.llm = LLMInterface(llm_provider)
        
        # Log which provider is being used
        provider_info = self.llm.get_provider_info()
        self.logger.info(f"Initialized validator with {provider_info['provider']} - {provider_info.get('model', 'N/A')}")
    
    def validate_extracted_data(self, title: str, abstract: str, conclusion: str, 
                               extracted_data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """
        Validate extracted data against original paper content
        
        Args:
            title: Paper title
            abstract: Paper abstract
            conclusion: Paper conclusion
            extracted_data: Data extracted by the extraction agent
            
        Returns:
            Validation results with issues and suggested corrections
        """
        try:
            # Format the validation prompt
            formatted_prompt = prompt_loader.format_prompt(
                "validation_prompt",
                title=title,
                abstract=abstract,
                conclusion=conclusion,
                extracted_data=json.dumps(extracted_data, indent=2)
            )
            
            if not formatted_prompt:
                self.logger.error("Failed to load validation prompt")
                return None
            
            # Get validation response from LLM
            response_text = self.llm.generate_response(formatted_prompt)
            
            if not response_text:
                self.logger.error(f"Empty validation response for paper: {title[:50]}...")
                return None
            
            self.logger.debug(f"Raw validation response: {response_text[:200]}...")
            
            # Parse JSON response
            validation_result = self.llm.extract_json_from_response(response_text)
            
            if validation_result:
                self.logger.debug(f"Successfully validated data for paper: {title[:50]}...")
                return validation_result
            else:
                self.logger.error(f"Failed to parse validation response for paper: {title[:50]}...")
                return None
                
        except Exception as e:
            self.logger.error(f"Error during validation for paper {title[:50]}...: {e}")
            return None
    
    def correct_extracted_data(self, title: str, abstract: str, conclusion: str,
                              original_extracted_data: Dict[str, Any], 
                              validation_feedback: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """
        Correct extracted data based on validation feedback
        
        Args:
            title: Paper title
            abstract: Paper abstract  
            conclusion: Paper conclusion
            original_extracted_data: Original extraction results
            validation_feedback: Validation results with issues and corrections
            
        Returns:
            Corrected extracted data
        """
        try:
            # Format the correction prompt
            formatted_prompt = prompt_loader.format_prompt(
                "correction_prompt",
                title=title,
                abstract=abstract,
                conclusion=conclusion,
                original_extracted_data=json.dumps(original_extracted_data, indent=2),
                validation_feedback=json.dumps(validation_feedback, indent=2)
            )
            
            if not formatted_prompt:
                self.logger.error("Failed to load correction prompt")
                return None
            
            # Get correction response from LLM
            response_text = self.llm.generate_response(formatted_prompt)
            
            if not response_text:
                self.logger.error(f"Empty correction response for paper: {title[:50]}...")
                return None
            
            self.logger.debug(f"Raw correction response: {response_text[:200]}...")
            
            # Parse JSON response
            corrected_data = self.llm.extract_json_from_response(response_text)
            
            if corrected_data:
                self.logger.debug(f"Successfully corrected data for paper: {title[:50]}...")
                return corrected_data
            else:
                self.logger.error(f"Failed to parse correction response for paper: {title[:50]}...")
                return None
                
        except Exception as e:
            self.logger.error(f"Error during correction for paper {title[:50]}...: {e}")
            return None
    
    def validate_and_correct(self, title: str, abstract: str, conclusion: str,
                            extracted_data: Dict[str, Any]) -> Tuple[Dict[str, Any], Dict[str, Any]]:
        """
        Complete validation and correction pipeline
        
        Args:
            title: Paper title
            abstract: Paper abstract
            conclusion: Paper conclusion  
            extracted_data: Original extraction results
            
        Returns:
            Tuple of (final_data, validation_summary)
            final_data: Corrected extraction results or original if validation passed
            validation_summary: Summary of validation and correction process
        """
        validation_summary = {
            "validation_attempted": True,
            "validation_successful": False,
            "correction_attempted": False,
            "correction_successful": False,
            "final_status": "FAILED",
            "issues_found": [],
            "corrections_applied": []
        }
        
        try:
            # Step 1: Validate the extracted data
            self.logger.info(f"Validating extracted data for paper: {title[:50]}...")
            validation_result = self.validate_extracted_data(title, abstract, conclusion, extracted_data)
            
            if not validation_result:
                self.logger.warning(f"Validation failed for paper: {title[:50]}...")
                validation_summary["final_status"] = "VALIDATION_FAILED"
                return extracted_data, validation_summary
            
            validation_summary["validation_successful"] = True
            validation_summary["issues_found"] = validation_result.get("issues_found", [])
            
            # Check validation status
            validation_status = validation_result.get("validation_status", "INVALID")
            confidence_score = validation_result.get("confidence_score", 0.0)
            
            self.logger.info(f"Validation status: {validation_status}, confidence: {confidence_score}")
            
            # If validation passed with high confidence, return original data
            if validation_status == "VALID" and confidence_score >= 0.9:
                validation_summary["final_status"] = "VALID_NO_CORRECTION_NEEDED"
                return extracted_data, validation_summary
            
            # If validation found issues, attempt correction
            if validation_status in ["NEEDS_CORRECTION", "INVALID"]:
                self.logger.info(f"Attempting correction for paper: {title[:50]}...")
                validation_summary["correction_attempted"] = True
                
                corrected_data = self.correct_extracted_data(
                    title, abstract, conclusion, extracted_data, validation_result
                )
                
                if corrected_data:
                    validation_summary["correction_successful"] = True
                    validation_summary["final_status"] = "CORRECTED"
                    
                    # Extract correction summary if present
                    if "correction_summary" in corrected_data:
                        validation_summary["corrections_applied"] = corrected_data["correction_summary"]
                        # Remove correction_summary from final data to keep clean structure
                        final_data = {k: v for k, v in corrected_data.items() if k != "correction_summary"}
                    else:
                        final_data = corrected_data
                    
                    self.logger.info(f"Successfully corrected data for paper: {title[:50]}...")
                    return final_data, validation_summary
                else:
                    self.logger.warning(f"Correction failed for paper: {title[:50]}...")
                    validation_summary["final_status"] = "CORRECTION_FAILED"
                    return extracted_data, validation_summary
            
            # Default case
            validation_summary["final_status"] = "UNKNOWN_STATUS"
            return extracted_data, validation_summary
            
        except Exception as e:
            self.logger.error(f"Error in validation pipeline for paper {title[:50]}...: {e}")
            validation_summary["final_status"] = "ERROR"
            return extracted_data, validation_summary
    
    def get_validation_stats(self, validation_summaries: list) -> Dict[str, Any]:
        """
        Generate statistics from multiple validation summaries
        
        Args:
            validation_summaries: List of validation summary dictionaries
            
        Returns:
            Statistics about validation performance
        """
        if not validation_summaries:
            return {}
        
        total_papers = len(validation_summaries)
        
        # Count by final status
        status_counts = {}
        for summary in validation_summaries:
            status = summary.get("final_status", "UNKNOWN")
            status_counts[status] = status_counts.get(status, 0) + 1
        
        # Count validation attempts
        validation_attempted = sum(1 for s in validation_summaries if s.get("validation_attempted", False))
        validation_successful = sum(1 for s in validation_summaries if s.get("validation_successful", False))
        
        # Count correction attempts
        correction_attempted = sum(1 for s in validation_summaries if s.get("correction_attempted", False))
        correction_successful = sum(1 for s in validation_summaries if s.get("correction_successful", False))
        
        # Count total issues found
        total_issues = sum(len(s.get("issues_found", [])) for s in validation_summaries)
        
        return {
            "total_papers": total_papers,
            "validation_rate": validation_attempted / total_papers if total_papers > 0 else 0,
            "validation_success_rate": validation_successful / validation_attempted if validation_attempted > 0 else 0,
            "correction_rate": correction_attempted / total_papers if total_papers > 0 else 0,
            "correction_success_rate": correction_successful / correction_attempted if correction_attempted > 0 else 0,
            "total_issues_found": total_issues,
            "avg_issues_per_paper": total_issues / total_papers if total_papers > 0 else 0,
            "status_distribution": status_counts
        }
