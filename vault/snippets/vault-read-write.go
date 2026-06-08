package main

import (
	"fmt"
	"log"

	"github.com/hashicorp/vault/api"
)

func main() {
	cfg := api.DefaultConfig()
	cfg.Address = "http://127.0.0.1:8200"

	client, err := api.NewClient(cfg)
	if err != nil {
		log.Fatalf("client error: %v", err)
	}

	client.SetToken("my-root-token")

	_, err = client.Logical().Write("secret/foo",
		map[string]interface{}{
			"value": "bar",
		})
	if err != nil {
		log.Fatalf("write error: %v", err)
	}

	data, err := client.Logical().Read("secret/foo")
	if err != nil {
		log.Fatalf("read error: %v", err)
	}

	val, ok := data.Data["value"].(string)
	if !ok {
		log.Fatal("value not a string")
	}
	fmt.Print(val)
}
