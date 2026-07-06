{
  "mini-smt": {
    "auto": {
      "addressPools": {
        "p2p": {
          "ipv4": "100.2.28.0/24",
          "ipv6": "fd42:021c::/64"
        },
        "tenant": {
          "ipv4": "10.2.28.0/24",
          "ipv6": "fd42:021c:1::/64"
        },
        "local": {
          "ipv4": "10.127.28.0/24",
          "ipv6": "fd42:021c:7f::/64"
        }
      },
      "communicationContract": {
        "relations": [
          {
            "id": "FS-540-HDS-010-SDS-010-SMS-040__mini-verify",
            "action": "allow",
            "from": {
              "kind": "tenant",
              "name": "client"
            },
            "to": {
              "kind": "external",
              "uplinks": [
                "internet-vlan4"
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
            "core-vlan4-client-dhcp-slaac"
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
          "core-vlan4-client-dhcp-slaac": {
            "role": "core",
            "external": "internet-vlan4",
            "uplinks": {
              "internet-vlan4": {
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
