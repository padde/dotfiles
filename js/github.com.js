var highlightReviewState = function() {
  const user = document.querySelector('.user-nav .avatar').alt.substring(1)
  for (let row of document.querySelectorAll('.js-issue-row:not(.unread)')) {
    const metaInfo = row.querySelector('.mt-1').innerText

    if (metaInfo.includes('Changes requested')) {
      row.style.boxShadow = 'inset 2px 0 0 rgba(222, 20, 11, 0.7)'
    } else if (metaInfo.includes('Approved')) {
      row.style.boxShadow = 'inset 2px 0 0 rgba(31, 127, 21, 0.7)'
    }

    if (metaInfo.includes(`by ${user}`)) {
      row.style.backgroundColor = 'rgba(230, 190, 10, 0.07)'
    }
  }
}

highlightReviewState()
document.addEventListener('DOMContentLoaded', highlightReviewState)
window.addEventListener('pushstate', highlightReviewState)
window.addEventListener('popstate', highlightReviewState)
