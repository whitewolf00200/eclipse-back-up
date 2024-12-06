({
	scan : function(component, event, helper) { 

        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0] ; 

        var App = {
            init: function() {
                App.attachListeners();
            } ,
            attachListeners: function() {
                 if(file)
                 {
                     var imgURL = URL.createObjectURL(file);
					 App.decode(imgURL);
                 }else{
                     component.set("v.codeOutput","Error !!! Select file to scan") ;
                 }
            },
            decode: function(src) {
                console.log(Quagga);
                Quagga.decodeSingle(
                    {
                      inputStream: {
                        size: 640,
                        singleChannel: false
                      },
                      locator: {
                        patchSize: "large",
                        halfSample: false
                      },
                      decoder: {
                        readers: ["upc_reader", "code_128_reader", "code_39_reader", "code_39_vin_reader", "ean_8_reader", "ean_reader", "upc_e_reader", "codabar_reader"]
                    },
                      locate: true,
                      src: src
                    },
                 function(result){
                      if(result && result.codeResult && result.codeResult.code)
                      {
                          alert(result.codeResult);
                        component.set("v.codeOutput",result.codeResult.code) ;
                      }else{
                          alert('error');
                        component.set("v.codeOutput","Error !!! Unable to read Barcode") ;
                      }
                    });
            }
        };
        App.init();

	}
})