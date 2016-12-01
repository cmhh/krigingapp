shinyServer(function(input, output, session){

   rasters <- reactiveValues(rasters=list())

   output$map <- renderLeaflet({
      leaflet() %>% addTiles(urlTemplate="//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png") %>%
         fitBounds(lng1=166.42615, lat1=-47.28999, lng2=178.57724, lat2=-34.39263) %>%
         addLayersControl(overlayGroups=c("raster"), position="topleft",
                          options = layersControlOptions(collapsed = FALSE))
   })

   observe({
      input$reset
      leafletProxy("map") %>%
         fitBounds(lng1=166.42615, lat1=-47.28999, lng2=178.57724, lat2=-34.39263)
   })

   output$tacontainer <- renderUI({
      req(input$region)
      selta <- tarc[regc2013==input$region, ta2013]
      selta <- selta[order(selta)]
      selta <- ta[ta2013%in%selta,]
      ta.list <- selta[,ta2013]
      names(ta.list) <- selta[,paste0("(", ta2013, ") ", ta2013_name)]
      selectInput("ta", "Territorial Authority:", ta.list)
   })

   observe({
      req(input$region)
      x <- regc2013[regc2013@data$regc2013==input$region,]
      bb <- x@bbox
      leafletProxy("map") %>% fitBounds(bb[1,1], bb[2,1], bb[1,2], bb[2,2])
   })

   observe({
      req(input$ta)
      leafletProxy("map") %>% clearShapes() %>% clearGroup("raster")
      x <- ta2013[ta2013@data$ta2013==input$ta,]
      leafletProxy("map") %>% addPolygons(data=x, fillOpacity=0, weight=2, color="black")

      if (is.null(rasters$rasters[[input$ta]])){
         if (file.exists(paste0("cache/", input$ta, ".rds"))){
            rasters$rasters[[input$ta]] <- readRDS(paste0("cache/", input$ta, ".rds"))
            r <- rasters$rasters[[input$ta]]
         }
         else{
            x <- gSimplify(x, 0.001, TRUE)
            bb <- x@bbox
            u <- min(diff(bb[1,]/100), diff(bb[2, ] / 100))
            gt <- GridTopology(c(bb[1, 1], bb[2, 1]), c(u, u),
                               c(ceiling(diff(bb[1, ]) / u), ceiling(diff(bb[2, ]) / u)))
            gr <- as(SpatialGrid(gt), "SpatialPixels")
            gr@proj4string <- x@proj4string
            gr <- gr[which((gr %over% x) == 1), ]

            y <- mbta[ta2013 == input$ta, mb2013]
            y <- mb[mb@data$mb2013 %in% y,]
            y <- y[which(!is.na(y@data$V0962)), ]
            y <- remove.duplicates(y, u*111132/1000)
            if (nrow(y) > 1000)
               y <- y[sample(nrow(y), 1000),]

            m <- vgm("Exp")
            f <- fit.variogram(variogram(V0962~1, y), m)
            if (f[2,"range"]<0) f[2,"range"] <- 1

            # ordinary kriging
            k <- krige(V0962~1, y, gr, model=f)

            r <- raster(k)
            rasters$rasters[[input$ta]] <- r
            saveRDS(r, paste0("cache/", input$ta, ".rds"))
         }
      }
      else r <- rasters$rasters[[input$ta]]

      leafletProxy("map") %>% addRasterImage(r, group="raster", opacity=0.7)
   })

})