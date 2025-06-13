window.addEventListener("message", function(event) {
    const data = event.data;

    if (data.action === "tts" && data.text) {
        const synth = window.speechSynthesis;
        let voices = synth.getVoices();
        let preferredVoice = null;

        // fallback pro asynchronní načtení hlasů
        const speak = () => {
            if (!voices.length) voices = synth.getVoices();

            if (data.voice) {
                preferredVoice = voices.find(v => v.name.toLowerCase().includes(data.voice.toLowerCase()));
            }

            // Pokud preferovaný hlas není, najdi ženský hlas pro daný jazyk
            if (!preferredVoice) {
                const langPrefix = (data.voice || "").substring(0, 2).toLowerCase(); // např. "cs"
                preferredVoice = voices.find(v =>
                    v.lang.toLowerCase().startsWith(langPrefix) &&
                    v.name.toLowerCase().includes("female") || v.name.toLowerCase().includes("zira") || v.name.toLowerCase().includes("iveta")
                );
            }

            // Pokud stále nic, vezmi jakýkoliv hlas
            if (!preferredVoice && voices.length) {
                preferredVoice = voices[0];
            }

            const utter = new SpeechSynthesisUtterance(data.text);
            if (preferredVoice) utter.voice = preferredVoice;
            synth.cancel(); // zruš předchozí
            synth.speak(utter);
        };

        // Případně odlož spuštění, dokud nejsou načteny hlasy
        if (!voices.length) {
            window.speechSynthesis.onvoiceschanged = speak;
        } else {
            speak();
        }
    }
});
