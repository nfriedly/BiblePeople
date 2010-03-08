$(document).ready(function(){

  /* functions for search results pages */
  
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
   
  /* functions for new / edit person pages */
  
  // autocomplete for the parents
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

  // when a person's name is entered or changed, run a search for verses containing that word.
  $("#names input").live("change", function(){
    // get the name and return if it's blank
    var name = $(this).val();
    if(name == "") return;
    
    // determine which target we're loading the results in
    var index = $("#names input").index(this);
    
    // find / create the target
    var target = $('#verses div.name-verses-'+index);
    if(target.length == 0){
      target = $('<div class="name-verses name-verses-'+index+'"></div>').appendTo('#verses');
    }
    
    // and lastly, load the data
    target.load('/people/verses?name='+name);
  }).change();
  
  // check/uncheck all verses for that name
  $('#verses input.check-all').live('change', function(){
    $(this).parent().find('p.verse input[type=checkbox]').attr('checked',$(this).attr('checked'));
  });
  
  // ajax in the pagination links
  $('#verses div.pagination a').live('click',function(){
    $('<div class="more-verses"></div>')
      .insertBefore($(this).parent('div.pagination'))
      .load($(this).attr('href'));
    $(this).before('<span>' + $(this).html() + '</span>').remove();
    return false;
  });
});
