Feature: Check GeLiNEA transformer

    Background: Specify transformer API
        Given a transformer at "https://translator.broadinstitute.org/gelinea"

    Scenario: Check GeLiNEA producer info
        Given the transformer
        when we fire "/transformer_info" query
        then the value of "name" should be "Gene-list network enrichment analysis"
        and the value of "function" should be "exporter"
        and the value of "knowledge_map.input_class" should be "gene"
        and the value of "knowledge_map.output_class" should be "pathway"
        and the size of "parameters" should be 3


    Scenario: Check GeLiNEA compound-list producer
        Given the transformer
        when we fire "/transform" query with the following body:
        """
        {
            "controls": [
                {
                    "name": "maximum p-value",
                    "value": "1e-04"
                },
                {
                    "name": "network",
                    "value": "STRING-human-700"
                },
                {
                    "name": "gene-set collection",
                    "value": "H - hallmark gene sets"
                }
            ],
            "collection": [
                {
                    "id": "HGNC:18017",
                    "identifiers": {
                        "entrez": "NCBIGene:23279"
                    }
                },
                {
                    "id": "HGNC:12017",
                    "identifiers": {
                        "entrez": "NCBIGene:7175"
                    }
                },
                {
                    "id": "HGNC:25525",
                    "identifiers": {
                        "entrez": "NCBIGene:55706"
                    }
                },
                {
                    "id": "HGNC:9021",
                    "identifiers": {
                        "entrez": "NCBIGene:5315"
                    }
                },
                {
                    "id": "HGNC:9380",
                    "identifiers": {
                        "entrez": "NCBIGene:5566"
                    }
                },
                {
                    "id": "HGNC:3350",
                    "identifiers": {
                        "entrez": "NCBIGene:2023"
                    }
                },
                {
                    "id": "HGNC:29929",
                    "identifiers": {
                        "entrez": "NCBIGene:79023"
                    }
                },
                {
                    "id": "HGNC:30379",
                    "identifiers": {
                        "entrez": "NCBIGene:81929"
                    }
                },
                {
                    "id": "HGNC:13666",
                    "identifiers": {
                        "entrez": "NCBIGene:8086"
                    }
                }
            ]
        }
        """
        then the size of the response is 1
        and the response contains the following entries in "id"
            | id                         |
            | MSigDB:HALLMARK_GLYCOLYSIS |
        and the response only contains the following entries in "id"
            | id                         |
            | MSigDB:HALLMARK_GLYCOLYSIS |
        and the response contains the following entries in "biolink_class"
            | biolink_class |
            | Pathway       |
        and the response only contains the following entries in "biolink_class"
            | biolink_class |
            | Pathway       |
