(function () {
    let delay = 20;
    sendString = async (text, iframe) => {
        if (!confirm('Paste ' +  text.split(/\n/).length + ' lines?'))
            return;
        const promptResult = prompt('Delay (in ms)', delay)
        if (!promptResult || isNaN(promptResult)) {
            return;
        } else {
            delay = parseInt(promptResult);
        }
        const canvas = iframe.contentDocument.getElementById('canvas-id');
        const stopButton = document.getElementById('stop-button');
        let stop = false;
        const setStop = () => {
            stop = true;
        };
        stopButton.addEventListener('click', setStop);
        stopButton.removeAttribute('disabled');
        canvas.focus();
        for (const x of text.split('')) {
            if (stop)
                break;
            await new Promise(resolve => setTimeout(resolve, delay));
            var needs_shift = x.match(/[A-Z!@#$%^&*()_+{}:\"<>?~|]/);
            let evt;
            if (needs_shift) {
                evt = new KeyboardEvent('keydown', {keyCode: 16});
                canvas.dispatchEvent(evt);
                evt = new KeyboardEvent('keydown', {key: x, shiftKey: true});
                canvas.dispatchEvent(evt);
                evt = new KeyboardEvent('keyup', {keyCode: 16});
               }else if (x == '\n'){
                   evt = new KeyboardEvent('keydown', {keyCode: 13});
                   canvas.dispatchEvent(evt);
                   await new Promise(resolve => setTimeout(resolve, delay));
                   evt = new KeyboardEvent('keyup', {keyCode: 13});
               }else{
                   evt = new KeyboardEvent('keydown', {key: x});
           }
           canvas.dispatchEvent(evt);
        }
        stopButton.removeEventListener('click', setStop);
        stopButton.setAttribute('disabled', true);
    };
    setTimeout(()=>{
            if (document.getElementById('paste-button') != null)
                return;
            const iframe = document.querySelector('iframe');
            const button = document.createElement('button');
            const stopButton = document.createElement('button');
            button.setAttribute('id', 'paste-button');
            stopButton.setAttribute('id', 'stop-button');
            stopButton.setAttribute('disabled', true);
            button.innerText = 'Paste-inator';
            stopButton.innerText = 'Stop Paste';
            button.addEventListener('click', () => {
                navigator.clipboard.readText().then(text =>{
                    window.sendString(text, iframe);
                });
            });
            iframe.parentElement.prepend(stopButton);
            iframe.parentElement.prepend(button);
            iframe.contentDocument.querySelector('canvas').setAttribute('id', 'canvas-id');
    }, 500);
})()
