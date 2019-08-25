// Expose references to window
window.MyApp = window.MyApp || {};

// window.$ = require('jquery');
window.iziToast = require('izitoast/dist/js/iziToast');

// Invoke third-party js in node_modules
// require('bootstrap/dist/js/bootstrap.bundle.js');

// Load our scripts when turbolinks is ready.
document.addEventListener('turbolinks:load', () => {
  markUserVotes();
  SubmitDictionarySearchOnSelectOption();
});

function markUserVotes() {
  const useVotes = document.querySelector('[data-upvoted-word-ids]').dataset.upvotedWordIds;
  document.querySelectorAll('.js-UpvoteThumb').forEach(node => {
    if (useVotes.includes(node.dataset.wordId)) {
      node.setAttribute('data-upvoted-by-current-user', true);
    }
  });
}

function SubmitDictionarySearchOnSelectOption() {
  const wordOptionsEl = document.querySelector('.js-DictionarySearch-input');
  if (wordOptionsEl) {
    wordOptionsEl.addEventListener('input', e => {
      // https://stackoverflow.com/questions/30022728/perform-action-when-clicking-html5-datalist-option
      const inputNode = e.target;
      const listId = inputNode.getAttribute('list');
      const options = document.getElementById(listId).childNodes;
      const submitButton = document.querySelector('.js-DictionarySearch-submit');

      for (let i = 0; i < options.length; i++) {
        if (options[i].innerText === inputNode.value) {
          submitButton.click();
          // console.log('word option item selected: ', inputNode.value);
          break;
        }
      }
    });
  }
}
