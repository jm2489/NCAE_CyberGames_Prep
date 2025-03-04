(function () {
    const delay = 1;
    sendString = function(text) {
        var el = document.querySelector("iframe").contentDocument.getElementById("canvas-id");
        text.split("").forEach(x=>{
            setTimeout(()=>{
                 var needs_shift = x.match(/[A-Z!@#$%^&*()_+{}:\"<>?~|]/);
                 let evt;
                 if (needs_shift) {

                     evt = new KeyboardEvent("keydown", {keyCode: 16});
                     el.dispatchEvent(evt);
                     evt = new KeyboardEvent("keydown", {key: x, shiftKey: true});
                     el.dispatchEvent(evt);
                     evt = new KeyboardEvent("keyup", {keyCode: 16});
                     el.dispatchEvent(evt);

                 }else{
                     evt = new KeyboardEvent("keydown", {key: x});
                }
                el.dispatchEvent(evt);
            }, delay);
        });

    };
    setTimeout(()=>{
            console.log("Starting up noVNC Copy/Paste (for Proxmox)");

            document.querySelector("iframe").contentDocument.querySelector("canvas").setAttribute("id", "canvas-id");

            document.querySelector("iframe").contentDocument.querySelector("canvas").addEventListener("mousedown", (e)=>{
                if(e.button == 2){ // Right Click
                    navigator.clipboard.readText().then(text =>{
                        window.sendString(text);
                    });
                }
            });
    }, 1000);
})()
