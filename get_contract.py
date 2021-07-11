
import requests
import json

#url = 'http://localhost:9090/wallet/getcontract'
url = 'http://localhost:9090/wallet/getcontract?value=41764978cc09424d13cc514635586aa12127630dee&visible=false'

headers = {
    "Accept": "application/json",
    "Content-Type": "application/json"
}

data = {
  "value": "410be9130c074811d862e6a72a31ce8951c4ce9cf3",
  "visible": False
}
# response = requests.post(url=url, data=json.dumps(data), headers=headers)
response = requests.get(url=url, headers=headers)

print(response.status_code, response.content)
