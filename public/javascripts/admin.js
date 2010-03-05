$(document).ready(function(){

  // only bother with this if we're on a page with verses
  if($("p.verse:first").length) {

     // create my word-actions div
     $('<div id="word-actions" class="hoverbox"><a href="/people/new" id="create-person">Create Person</a></div>')
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
        CPLink.attr('href', '/people/new?name=' + Word.text().replace(/[^a-z ]/ig,''));
     });
   
   }
 
 // autocomplete for the parents (only runs on pages with #father_name or #mother_name fields)
 $('#father_name, #mother_name').autocomplete(
    "/people/parent", // .json or .xml also work
    {
      extraParams:  {
        child: function(){ return $('#person_name').val(); }, 
        which: function(){ return document.activeElement.id.split("_")[0]; }
      },
      formatItem: function(row){
        return row[0];
      }
  }).result(function(event, data, formatted) {
    $("#person_"+this.id.split("_")[0]+"_id").val(data[1]);
 });
 
 // add name, only runs on new person pages
 $('#names a.add').click(function(){
      $("#names p:first").clone().insertAfter("#names p:last");
      $("#names p:last input").val("");
      return false;
  });
  

});
