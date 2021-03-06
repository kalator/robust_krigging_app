#install.packages("geoR")
#install.packages("rstudioapi")
#install.packages("georob")
#install.packages('rsconnect')

#
#library(rsconnect)
library(rstudioapi)
library(shiny)
library(shinydashboard)

library(geoR)
library(georob)
library(lattice)

data(s100)

library(georob)
data(meuse, package="sp")
r.lm <- lm(log(zinc)~sqrt(dist)+ffreq, meuse)
r.sv <- sample.variogram(residuals(r.lm), locations=meuse[, c("x","y")],
                         lag.dist.def=100, max.lag=2000,
                         estimator="ch")
#plot(r.sv)




shinyServer
(
  function(input,output,session)
    {
    
    bin1 <- variog(s100, uvec=seq(0,1,l=11))
    
    output$nugetSlider <- renderUI({
      sliderInput("nugget","Nugget",min = 0,max = round(min(bin1$v),2),value = 0)
    })
    
    output$binSlider <- renderUI({
      sliderInput("bins","Bins",min = 0,max = 100,value = 11)
    })
    
    output$sillSlider <- renderUI({
      sliderInput("sill","Sill",min = 0,max = 2*round(max(bin1$v),2),value = 1)
    })
    
    output$rangeSlider <- renderUI({
      sliderInput("range","Range",min = 0,max = 1,value = 0.3)
    })
    
    output$variogram <- renderPlot({
        nuget <- 0
        choosen <-switch(input$vario_type,
                         'Spherical' = "sph",
                         'Exponential' = "exp",
                         'Gaussian' = "gaussian",
                         'Cubic' = 'cubic'
                       )
        nuget <- input$nugget
        bins <- input$bins
        sill <- input$sill
        range <- input$range
        
        bin1 <- variog(s100, uvec=seq(0,1,l=bins))
        plot(bin1, col = 'red')
        if(input$def_vario){
          ols.n <- variofit(bin1, ini = c(1,0.5), nugget=0.5, weights="equal")
          lines(ols.n, lty = 2, max.dist = 1)
        }
        lines.variomodel(cov.model = choosen, cov.pars = c(sill, range), nugget = nuget, max.dist = 1,  lwd = 3, col='purple')

      }      )
    
    output$nonrob_krig <-renderPlot({
      nuget <- 0
      choosen <-switch(input$vario_type,
                       'Spherical' = "sph",
                       'Exponential' = "exp",
                       'Gaussian' = "gaussian",
                       'Cubic' = 'cubic'
      )
      nuget <- input$nugget
      bins <- input$bins
      sill <- input$sill
      range <- input$range
      
      s100.ml <- variofit(bin1, cov.model = choosen, ini.cov.pars = c(sill, range), nugget = nuget, max.dist = 1)
      s100.gr <- expand.grid((0:100)/100, (0:100)/100)
      s100.kc <- krige.conv(s100, locations = s100.gr, krige = krige.control(obj.model = s100.ml))
      levelplot(predict~s100.gr$Var1*s100.gr$Var2, data = s100.kc,col.regions = terrain.colors(100),xlab = "X", ylab = "Y")
      #breaks <- seq(min(s100$data), max(s100$data),length.out=10)
      
      
    })
    
    randomVals <- eventReactive(input$class_krig, {
    
          })
    
    
      
      
      
      output$nugetSlider2 <- renderUI({
        sliderInput("nugget2","Nugget",min = 0,max = round(min(r.sv$gamma),2),value = 0.05)
      })
      

      output$sillSlider2 <- renderUI({
        sliderInput("sill2","Sill",min = 0,max = 2*round(max(r.sv$gamma),2),value = 0.1)
      })
      
      output$rangeSlider2 <- renderUI({
        sliderInput("range2","Range",min = 1,max = 2000,value = 1000)
      })
      
      
      
      
      output$robustvariogram <- renderPlot({
        nuget2 <- 0.05
        sill2 <- 0.1
        range2 <- 1000
        
        choosen <- switch(input$variogram.model,
                          'Spherical' = "RMspheric",
                          'Exponential' = "RMexp",
                          'Gaussian' = "RMgauss",
                          'Cubic' = "RMcubic")
        

        nuget2 <- input$nugget2
        sill2 <- input$sill2
        range2 <- input$range2
        
        plot(r.sv)
        r.sv.spher <- fit.variogram.model(r.sv, variogram.mode=choosen,
                                                param=c(variance=(sill2*sill2), nugget=(nuget2*nuget2), scale=range2))
        
        lines(r.sv.spher,   lwd = 10, col='purple')
        
        
      })
      
#      output$rob_kriging  <- renderPlot({
#        library(sp)
#        r.georob.m0.spher.reml <- georob(log(zinc)~sqrt(dist)+ffreq, meuse, locations=~x+y,
#                                         variogram.model="RMspheric", param=c(variance=0.1, nugget=0.05, scale=1000),
#                                         tuning.psi=1000)
#        r.georob.m0.spher.ml <- update(r.georob.m0.spher.reml,
#                                       control=control.georob(ml.method="ML"))
#        
#        extractAIC(r.georob.m0.spher.reml, REML=TRUE)
#        extractAIC(r.georob.m0.spher.ml)
#        r.georob.m0.spher.ml
##        
#        data(meuse.grid)
#        coordinates(meuse.grid) <- ~x+y
#        gridded(meuse.grid) <- TRUE
        
        
        
#        r.pk <- predict(r.georob.m0.spher.reml, newdata=meuse.grid,
#                        control=control.predict.georob(extended.output=TRUE))
#        r.pk <- lgnpp(r.pk)
#        str(r.pk)
        
#        brks <- c(25, 50, 75, 100, 150, 200, seq(500, 3500,by=500))
#        pred <- spplot(r.pk, zcol="lgn.pred", at=brks, main="prediction")
#        plot(pred)
        
        
        
#      })
    
  }
 
) 