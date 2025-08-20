from google.adk.agents import Agent
from dotenv import load_dotenv

load_dotenv()

root_agent = Agent(
    name = "Schema_Designer",
    description = "This agent processes the abstract information and extracts the relevant data on materials.",
    tools = [],
    model = "gemini-2.5-flash",
    instruction = """
                    You are the DATA MINING agent. 
                    Your job is to read an ABSTRACT portion of a scientific paper text and decide on the relevant 
                    properties for carbon capture / sustainability materials that are REPORTED IN THE PAPER.

                    INSTRUCTIONS:
                    1. Carefully scan the entire text for properties reported for materials.
                    2. Include the properties of the materials that are ONLY MENTIONED in the text.
                    3. Produce the extracted properties as a JSON array of property names. :

                    EXAMPLES:

                    1. ABSTRACT:
                        "Abstract: Carbon dioxide (CO2) capture technology is a prominent way to mitigate global
                        climate change originating from the excessive emission of greenhouse gas CO2. The
                        structural modification of adsorbents with amine is a new attractive strategy to enhance their
                        CO2 adsorption efficiency under low pressure. The current work is looking to boost the CO2
                        uptake performance of Zeolitic imidazolate framework-8 (ZIF-8) impregnated with
                        aminoethylethanolamine (AEEA) inside the porous network of crystalline ZIF-8 nanoparticles
                        via the wet functionalization process due to the enormous surface area and remarkable
                        thermally and chemical stability of ZIF-8. The parent ZIF-8 and amine incorporated ZIF-8
                        adsorbents were carefully synthesized and characterized by various approaches through
                        HRXRD, Micro Raman, FTIR, FESEM, TEM, EDS, TGA, XPS, BET, and CHNS methods. The CO2
                        capture behaviour of materials was examined using the iSorb HP2 adsorption equipment
                        under pressure and temperature swing circumstances, particularly within the spectrum of 0
                        to 30 bar and 25 to 80 °C. Response surface methodology (RSM) based on the Box-Behnken
                        design (BBD) was exploited to design experiments and investigate the optimum conditions
                        for the desirable response i.e. CO2 adsorption performance, which was affected by three
                        distinct variables: temperature, CO2 partial pressure, and AEEA loading. Additionally, the CO2
                        adsorption was mathematically modeled using numerous isotherm models. The CO2
                        adsorption capacity (3.581 mmol/g) of the prime adsorbent 30 % AEEA treated ZIF-8 was
                        highest among the amine incorporated ZIF-8 samples which was 4.15 times higher than that
                        of the pure ZIF-8 material (0.862 mmol/g) at 25 °C/1 bar partial pressure."

                        OUTPUT:
                        [
                        {
                            "property": "Adsorbent Material",
                            "value": "Zeolitic imidazolate framework-8 (ZIF-8) impregnated with aminoethylethanolamine (AEEA)"
                        },
                        {
                            "property": "Pressure Range",
                            "value": "0 to 30 bar"
                        },
                        {
                            "property": "Temperature Range",
                            "value": "25 to 80 °C"
                        },
                        {
                            "property": "Maximum CO2 Adsorption Capacity",
                            "value": "3.581 mmol/g"
                        },
                        {
                            "property": "Adsorption Enhancement",
                            "value": "4.15 times higher than that of the pure ZIF-8 material (0.862 mmol/g)"
                        }
                        ]


                    OUTPUT FORMAT:
                    - Only output valid JSON array of strings (no commentary).
"""
)