var highlightReviewState = function() {
  $('.js-issue-row').each(function() {
    var reviewState = $(this).find('.mt-1').text();
    if (reviewState.includes('Changes requested')) {
      $(this).find('.d-table').css({background: 'rgba(222, 20, 11, 0.1)'});
    } else if (reviewState.includes('Approved')) {
      $(this).find('.d-table').css({background: 'rgba(31, 127, 21, 0.1)'});
    }
  });
};

$(function() {
  $('.outdated-diff-comment-container').addClass('open');

  highlightReviewState();
  $(window).on('pushstate popstate', highlightReviewState);
  // HACK: make sure that we highlight review states after ajax pagination or
  // search reloaded the issues list. Maybe there's a better way to do this :/
  $(document).on('click', function() {
    var maxTries = 100;
    var interval = setInterval(function() {
      if (maxTries-- == 0) { clearInterval(interval) };
      highlightReviewState();
    }, 100);
  });
});
