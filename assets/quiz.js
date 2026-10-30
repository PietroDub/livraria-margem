/* Quiz de recuperação. Cada questão traz opções com o mesmo número de palavras.
   O gabarito só aparece depois do clique. */
(function () {
  var node = document.getElementById("quiz-data");
  var root = document.getElementById("quiz");
  if (!node || !root) return;

  var questions = JSON.parse(node.textContent);
  var answered = 0;
  var correct = 0;

  var score = document.createElement("p");
  score.className = "score";
  score.textContent = "0 de " + questions.length;

  questions.forEach(function (question, index) {
    var block = document.createElement("fieldset");
    block.className = "q";

    var prompt = document.createElement("p");
    prompt.className = "prompt";
    prompt.textContent = index + 1 + ". " + question.prompt;

    var options = document.createElement("div");
    options.className = "options";

    var feedback = document.createElement("p");
    feedback.className = "feedback";

    question.options.forEach(function (label, optionIndex) {
      var button = document.createElement("button");
      button.type = "button";
      button.textContent = label;
      button.addEventListener("click", function () {
        if (block.dataset.done) return;
        block.dataset.done = "1";
        var hit = optionIndex === question.answer;
        button.classList.add("chosen", hit ? "right" : "wrong");
        Array.prototype.forEach.call(options.querySelectorAll("button"), function (el) {
          el.disabled = true;
        });
        feedback.classList.add(hit ? "right" : "wrong");
        feedback.textContent = (hit ? "Certo. " : "Ainda não. ") + question.why;
        answered += 1;
        if (hit) correct += 1;
        score.textContent = correct + " de " + questions.length + " sem consultar de novo";
      });
      options.appendChild(button);
    });

    block.appendChild(prompt);
    block.appendChild(options);
    block.appendChild(feedback);
    root.appendChild(block);
  });

  root.appendChild(score);
})();
