{
  "mini-smt": {
    "auto": {
      "addressPools": {
        "p2p": {
          "ipv4": "100.3.172.0/24",
          "ipv6": "fd42:03ac::/64"
        },
        "tenant": {
          "ipv4": "10.3.172.0/24",
          "ipv6": "fd42:03ac:1::/64"
        },
        "local": {
          "ipv4": "10.127.172.0/24",
          "ipv6": "fd42:03ac:7f::/64"
        }
      },
      "communicationContract": {
        "relations": [
          {
            "id": "FS-940-HDS-010-SDS-020-SMS-080__mini-verify",
            "action": "allow",
            "from": {
              "kind": "tenant",
              "name": "client"
            },
            "to": {
              "kind": "external",
              "uplinks": [
                "testnet"
              ]
            },
            "trafficType": "any",
            "priority": 100
          }
        ],
        "trafficTypes": [
          {
            "name": "any",
            "match": [
              {
                "family": "any",
                "proto": "any"
              }
            ]
          }
        ]
      },
      "topology": {
        "links": [
          [
            "client-edge",
            "downstream-selector"
          ],
          [
            "downstream-selector",
            "policy"
          ],
          [
            "policy",
            "upstream-selector"
          ],
          [
            "upstream-selector",
            "testnet-edge"
          ]
        ],
        "nodes": {
          "client-edge": {
            "role": "access",
            "attachments": [
              {
                "kind": "tenant",
                "name": "client"
              }
            ]
          },
          "downstream-selector": {
            "role": "downstream-selector"
          },
          "policy": {
            "role": "policy"
          },
          "upstream-selector": {
            "role": "upstream-selector"
          },
          "testnet-edge": {
            "role": "core",
            "external": "testnet",
            "uplinks": {
              "testnet": {
                "ipv4": [
                  "0.0.0.0/0"
                ],
                "ipv6": [
                  "::/0"
                ]
              }
            }
          }
        }
      }
    }
  }
}
