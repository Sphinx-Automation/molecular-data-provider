Feature: Check MoleProDB transformer

    Background: Specify transformer API
        Given a transformer at "https://translator.broadinstitute.org/moleprodb"


    Scenario: Check producer transformer info
        Given the transformer
        when we fire "/elements/transformer_info" query
        then the value of "name" should be "MoleProDB node producer"
        and the value of "knowledge_map.input_class" should be "none"
        and the value of "knowledge_map.output_class" should be "any"
        and the value of "version" should be "2.4.3"
        and the value of "properties.source_version" should be "2.4.2 (2021-11-20)"
        and the size of "parameters" should be 1


    Scenario: Check names producer transformer info
        Given the transformer
        when we fire "/names/transformer_info" query
        then the value of "name" should be "MoleProDB name producer"
        and the value of "knowledge_map.input_class" should be "none"
        and the value of "knowledge_map.output_class" should be "any"
        and the value of "version" should be "2.4.3"
        and the value of "properties.source_version" should be "2.4.2 (2021-11-20)"
        and the size of "parameters" should be 1


    Scenario: Check transformer info for connections transformer
        Given the transformer
        when we fire "/connections/transformer_info" query
        then the value of "name" should be "MoleProDB connections transformer"
        and the value of "knowledge_map.input_class" should be "any"
        and the value of "knowledge_map.output_class" should be "any"
        and the value of "version" should be "2.4.3"
        and the value of "properties.source_version" should be "2.4.2 (2021-11-20)"
        and the size of "parameters" should be 6


    Scenario: Check transformer info for hierarchy transformer
        Given the transformer
        when we fire "/hierarchy/transformer_info" query
        then the value of "name" should be "MoleProDB hierarchy transformer"
        and the value of "knowledge_map.input_class" should be "any"
        and the value of "knowledge_map.output_class" should be "any"
        and the value of "version" should be "2.4.3"
        and the value of "properties.source_version" should be "2.4.2 (2021-11-20)"
        and the size of "parameters" should be 2


    Scenario: Check node producer
        Given the transformer
        when we fire "/elements/transform" query with the following body:
        """
        {
            "controls": [
                {
                    "name": "id",
                    "value": "CID:2244"
                }
            ]
        }
        """
        then the size of the response is 1
        and the response contains the following entries in "source"
            | source  |
            | MolePro |
        and the response only contains the following entries in "source"
            | source  |
            | MolePro |
        and the response contains the following entries in "name" of "names_synonyms" array
            | name                 |
            | aspirin              |
            | Aspirin              |
            | Acetylsalicylic acid |


    Scenario: Check node producer with multivalued input
        Given the transformer
        when we fire "/elements/transform" query with the following body:
        """
        {
            "controls": [
                {
                    "name": "id",
                    "value": "CID:2244"
                },
                {
                    "name": "id",
                    "value": "HGNC:11998"
                },
                {
                    "name": "id",
                    "value": "DrugBank:DB00945"
                }
            ]
        }
        """
        then the size of the response is 2
        and the response contains the following entries in "source"
            | source  |
            | MolePro |
        and the response only contains the following entries in "source"
            | source  |
            | MolePro |
        and the response contains the following entries in "name" of "names_synonyms" array
            | name                 |
            | aspirin              |
            | Aspirin              |
            | Acetylsalicylic acid |
            | tumor protein p53    |
        and the response contains the following entries in "id"
            | id            |
            | CID:2244      |
            | NCBIGene:7157 |
        and the response only contains the following entries in "id"
            | id            |
            | CID:2244      |
            | NCBIGene:7157 |


    Scenario: Check name producer
        Given the transformer
        when we fire "/names/transform" query with the following body:
        """
        {
            "controls": [
                {
                    "name": "name",
                    "value": "aspirin"
                }
            ]
        }
        """
        then the size of the response is 1
        and the response contains the following entries in "source"
            | source  |
            | MolePro |
        and the response only contains the following entries in "source"
            | source  |
            | MolePro |
        and the response contains the following entries in "name" of "names_synonyms" array
            | name                 |
            | aspirin              |
            | Aspirin              |
            | Acetylsalicylic acid |


    Scenario: Check connections transformer
        Given the transformer
        when we fire "/connections/transform" query with the following body:
        """
        {
            "controls": [
                {
                    "name": "biolink_class",
                    "value": "biolink:Gene"
                }
            ],
            "collection": [
                {
                    "biolink_class": "ChemicalSubstance",
                    "id": "CHEBI:52717",
                    "provided_by": "pharos",
                    "source": "pharos",
                    "identifiers": {
                        "chembl": "CHEMBL325041",
                        "pubchem": "CID:387447"
                    }
                },
                {
                    "biolink_class": "ChemicalSubstance",
                    "id": "CHEBI:15365",
                    "provided_by": "pharos",
                    "source": "pharos",
                    "identifiers": {
                        "chembl": "ChEMBL:CHEMBL25",
                        "pubchem": "CID:2244"
                    }
                }
            ]
        }
        """
        then the size of the response is 144
        and the response contains the following entries in "source"
            | source      |
            | MolePro |
        and the response only contains the following entries in "source"
            | source      |
            | MolePro |
        and the response contains the following entries in "biolink_class"
            | biolink_class |
            | Gene          |
        and the response only contains the following entries in "biolink_class"
            | biolink_class |
            | Gene          |
        and the response contains the following entries in "source_element_id" of "connections" array
            | source_element_id |
            | CHEBI:52717       |
            | CHEBI:15365       |
        and the response only contains the following entries in "source_element_id" of "connections" array
            | source_element_id |
            | CHEBI:52717       |
            | CHEBI:15365       |


    Scenario: Check connections transformer with resticted object class
        Given the transformer
        when we fire "/connections/transform" query with the following body:
        """
        {
            "controls": [
                {
                    "name": "biolink_class",
                    "value": "biolink:Disease"
                }
            ],
            "collection": [
                {
                    "biolink_class": "ChemicalSubstance",
                    "id": "CHEBI:52717",
                    "provided_by": "pharos",
                    "source": "pharos",
                    "identifiers": {
                        "chembl": "CHEMBL325041",
                        "pubchem": "CID:387447"
                    }
                },
                {
                    "biolink_class": "ChemicalSubstance",
                    "id": "CHEBI:15365",
                    "provided_by": "pharos",
                    "source": "pharos",
                    "identifiers": {
                        "chembl": "ChEMBL:CHEMBL25",
                        "pubchem": "CID:2244"
                    }
                }
            ]
        }
        """
        then the size of the response is 162
        and the response contains the following entries in "source"
            | source      |
            | MolePro |
        and the response only contains the following entries in "source"
            | source      |
            | MolePro |
        and the response contains the following entries in "biolink_class"
            | biolink_class |
            | Disease       |
        and the response only contains the following entries in "biolink_class"
            | biolink_class |
            | Disease       |
        and the response contains the following entries in "source_element_id" of "connections" array
            | source_element_id |
            | CHEBI:52717       |
            | CHEBI:15365       |
        and the response only contains the following entries in "source_element_id" of "connections" array
            | source_element_id |
            | CHEBI:52717       |
            | CHEBI:15365       |


    Scenario: Check connections transformer with resticted predicate
        Given the transformer
        when we fire "/connections/transform" query with the following body:
        """
        {
            "controls": [
                {
                    "name": "predicate",
                    "value": "biolink:is_substrate_of"
                }
            ],
            "collection": [
                {
                    "biolink_class": "ChemicalSubstance",
                    "id": "CHEBI:52717",
                    "provided_by": "pharos",
                    "source": "pharos",
                    "identifiers": {
                        "chembl": "CHEMBL325041",
                        "pubchem": "CID:387447"
                    }
                },
                {
                    "biolink_class": "ChemicalSubstance",
                    "id": "CHEBI:15365",
                    "provided_by": "pharos",
                    "source": "pharos",
                    "identifiers": {
                        "chembl": "ChEMBL:CHEMBL25",
                        "pubchem": "CID:2244"
                    }
                }
            ]
        }
        """
        then the size of the response is 12
        and the response contains the following entries in "source"
            | source      |
            | MolePro |
        and the response only contains the following entries in "source"
            | source      |
            | MolePro |
        and the response contains the following entries in "biolink_class"
            | biolink_class |
            | Gene          |
            | Protein       |
        and the response only contains the following entries in "biolink_class"
            | biolink_class |
            | Gene          |
            | Protein       |
        and the response contains the following entries in "source_element_id" of "connections" array
            | source_element_id |
            | CHEBI:52717       |
            | CHEBI:15365       |
        and the response only contains the following entries in "source_element_id" of "connections" array
            | source_element_id |
            | CHEBI:52717       |
            | CHEBI:15365       |


    Scenario: Check connections transformer with resticted object id
        Given the transformer
        when we fire "/connections/transform" query with the following body:
        """
        {
            "controls": [
                {
                    "name": "id",
                    "value": "HGNC:2621"
                }
            ],
            "collection": [
                {
                    "biolink_class": "ChemicalSubstance",
                    "id": "CHEBI:52717",
                    "provided_by": "pharos",
                    "source": "pharos",
                    "identifiers": {
                        "chembl": "CHEMBL325041",
                        "pubchem": "CID:387447"
                    }
                },
                {
                    "biolink_class": "ChemicalSubstance",
                    "id": "CHEBI:15365",
                    "provided_by": "pharos",
                    "source": "pharos",
                    "identifiers": {
                        "chembl": "ChEMBL:CHEMBL25",
                        "pubchem": "CID:2244"
                    }
                }
            ]
        }
        """
        then the size of the response is 1
        and the response contains the following entries in "id"
            | id            |
            | NCBIGene:1557 |
        and the response only contains the following entries in "id"
            | id            |
            | NCBIGene:1557 |
        and the response contains the following entries in "source"
            | source  |
            | MolePro |
        and the response only contains the following entries in "source"
            | source  |
            | MolePro |
        and the response contains the following entries in "biolink_class"
            | biolink_class |
            | Gene          |
        and the response only contains the following entries in "biolink_class"
            | biolink_class |
            | Gene          |
        and the response contains the following entries in "source_element_id" of "connections" array
            | source_element_id |
            | CHEBI:52717       |
            | CHEBI:15365       |
        and the response only contains the following entries in "source_element_id" of "connections" array
            | source_element_id |
            | CHEBI:52717       |
            | CHEBI:15365       |


    Scenario: Check hierarchy transformer
        Given the transformer
        when we fire "/hierarchy/transform" query with the following body:
        """
        {
            "controls": [
                {
                    "name": "name_source",
                    "value": "MolePro"
                },
                {
                    "name": "element_attribute",
                    "value": "biolink:publication"
                }
            ],
            "collection": [
                {
                    "biolink_class": "Disease",
                    "id": "MESH:D003924",
                    "provided_by": "SRI node normalizer",
                    "source": "SRI node normalizer",
                    "identifiers": {
                        "mondo": "MONDO:0005148"
                    }
                }
            ]
        }
        """
        then the size of the response is 15
        and the response contains the following entries in "id"
            | id            |
            | MONDO:0005148 |
            | MONDO:0001076 |
            | MONDO:0005015 |
            | MONDO:0004335 |
            | MONDO:0000001 |
            | MONDO:0005066 |
            | MONDO:0006022 |
            | MONDO:0005151 |
            | MONDO:0005020 |
            | MONDO:0003847 |
            | MONDO:0019052 |
            | MONDO:0002356 |
            | MONDO:0012819 |
            | MONDO:0002908 |
            | MONDO:0014488 |
        and the response only contains the following entries in "id"
            | id            |
            | MONDO:0005148 |
            | MONDO:0001076 |
            | MONDO:0005015 |
            | MONDO:0004335 |
            | MONDO:0000001 |
            | MONDO:0005066 |
            | MONDO:0006022 |
            | MONDO:0005151 |
            | MONDO:0005020 |
            | MONDO:0003847 |
            | MONDO:0019052 |
            | MONDO:0002356 |
            | MONDO:0012819 |
            | MONDO:0002908 |
            | MONDO:0014488 |
        and the response contains the following entries in "source"
            | source  |
            | MolePro |
        and the response only contains the following entries in "source"
            | source  |
            | MolePro |
        and the response contains the following entries in "biolink_class"
            | biolink_class |
            | Disease       |
        and the response only contains the following entries in "biolink_class"
            | biolink_class |
            | Disease       |
        and the response contains the following entries in "source_element_id" of "connections" array
            | source_element_id |
            | MESH:D003924      |
        and the response only contains the following entries in "source_element_id" of "connections" array
            | source_element_id |
            | MESH:D003924      |
