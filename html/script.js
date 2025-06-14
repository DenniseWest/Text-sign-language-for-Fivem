window.addEventListener('message', function (event) {
    if (event.data.action === 'tts' && event.data.text) {
        const utterance = new SpeechSynthesisUtterance(event.data.text);
        utterance.lang = 'cs-CZ';
        utterance.voice = pickFemaleVoice(utterance.lang);
        speechSynthesis.speak(utterance);
    }
});

function pickFemaleVoice(lang) {
    const voices = speechSynthesis.getVoices();
    const filtered = voices.filter(v => v.lang === lang && v.name.toLowerCase().includes("female"));
    return filtered[0] || voices.find(v => v.lang === lang) || voices[0];
}

speechSynthesis.onvoiceschanged = () => {};