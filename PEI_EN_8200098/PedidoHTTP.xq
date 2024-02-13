
let $json-data := '{
  "dataSource": "AtlasCluster",
  "database": "PhoneForYou",
  "collection":  "CustomerMerge",
      "pipeline": [
        
       
  {
    "$lookup": {
      "from": "Sales_header",
      "localField": "id",
      "foreignField": "customer_id",
      "as": "Faturas"
    }
  },
  {
    "$unwind": "$Faturas"
  },
  {
    "$lookup": {
      "from": "Sales_line",
      "localField": "Faturas.invoice_id",
      "foreignField": "invoice_id",
      "as": "Vendas"
    }
  },
  {
    "$unwind": "$Vendas"
  },
  {
    "$lookup": {
      "from": "ProdutosCategorias",
      "localField": "Vendas.product_id",
      "foreignField": "id",
      "as": "Produto"
    }
  },
  {
    "$unwind": "$Produto"
  },
  {
    "$project": {
      "Cliente": {
        "PrimeiroNome": "$first_name",
        "UltimoNome": "$last_name",
        "Email": "$Email",
        "Morada": {
          "País": "$Morada.País",
          "Cidade": "$Morada.Cidade",
          "CodigoPostal": "$Morada.CodigoPostal"
        },
        "TipoCliente": "$Tipo_Cliente",
        "ComprasRealizadas": "$ComprasRealizadas",
        "ValorTotal": "$ValorTotal"
      },
      "Produtos": {
        "Codigo": "$Produto.id",
        "Marca": "$Produto.brand",
        "Modelo": "$Produto.model",
        "PreçoAtual": "$Produto.list_price",
        "Categorias": "$Produto.Categories"
      },
      "Fatura": {
        "CodigoFatura": "$Faturas.invoice_id",
        "DataVenda": "$Faturas.date",
        "CodigoCliente": "$Faturas.customer_id",
        "ValorTotalVenda": "$Faturas.ValorTotal",
        "LinhaVenda": {
          "NumeroLinha": "$Vendas.id",
          "CodigoProduto": "$Vendas.product_id",
          "QuantidadeProduto": "$Vendas.quantity",
          "ValorTotalLinha": "$Vendas.total_with_vat"
        }
      }
    }
  }
]
}'
 
  let $request :=
    http:send-request(<http:request method='post' >
 <http:header name="api-key" value="nkp9idOdnt8OrTjHgYzLv2lYMbkvs819JITvydzOTaaHpUpIX9l84IiFwnqQd6KA"/>
 <http:body media-type='application/json'/>
 </http:request> ,
 "https://eu-west-2.aws.data.mongodb-api.com/app/data-fvnay/endpoint/data/v1/action/aggregate", $json-data)
 

return $request[2]
