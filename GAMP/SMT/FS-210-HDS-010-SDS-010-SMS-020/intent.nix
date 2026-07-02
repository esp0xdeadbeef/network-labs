{
  "mini-smt": {
    "auto": {
      "addressPools": {
        "p2p": {
          "ipv4": "100.0.210.0/24",
          "ipv6": "fd42:00d2::/64"
        },
        "tenant": {
          "ipv4": "10.0.210.0/24",
          "ipv6": "fd42:00d2:1::/64"
        },
        "local": {
          "ipv4": "10.127.210.0/24",
          "ipv6": "fd42:00d2:7f::/64"
        }
      },
      "communicationContract": {
        "relations": [
          {
            "id": "FS-210-HDS-010-SDS-010-SMS-020__mini-verify",
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
