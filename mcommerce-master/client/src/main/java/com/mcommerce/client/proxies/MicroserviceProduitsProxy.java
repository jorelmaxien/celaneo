package com.mcommerce.client.proxies;

import com.mcommerce.client.beans.ProductBean;
import org.springframework.cloud.netflix.ribbon.RibbonClient;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;
import java.util.Optional;

@FeignClient(name = "zuul-server")
@RibbonClient(name = "microservice-produits")
public interface MicroserviceProduitsProxy {

    @GetMapping(value = "/microservice-produits/Produits")
    List<ProductBean> listeDesProduits();

    @GetMapping( value = "/microservice-produits/Produits/{id}")
    ProductBean recupererUnProduit(@PathVariable("id") int id);

}
