$(document).ready(function(){

 // create my word-actions div
 $('<div id="word-actions" class="hoverbox"><a href="#" id="create-person">Create Person</a></div>')
    .appendTo('body');
 var WordActions = $('#word-actions');
 var CPLink = $('#create-person');
 var WAWidth = WordActions.width()

 // placeholder for the current selected word
 var Word;

 // event when a word is clicked
 $("p.verse span").live('click',function(){
    if(Word){
      Word.removeClass('active-word');
    }
    Word = $(this);
    Word.addClass('active-word');
    
    // show the actions box
    var offset = Word.offset();
    offset.top = offset.top - 2;
    offset.left = offset.left - (WAWidth - Word.width())/2;
    WordActions.offset(offset);

    // update the links
    CPLink.attr('href', '/people/new?name=' + Word.text().replace(/[^a-z ]/i,''));
 });
});