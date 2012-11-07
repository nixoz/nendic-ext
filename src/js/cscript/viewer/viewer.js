/**
 * 사전 뷰어 모듈
 *
 * @author ohgyun@gmail.com
 * @version 2012.11.08
 */
define([

  'jquery',
  'cscript/viewer/template'

], function ($, template) {

  var _$wrapper = $('<div>')
      .attr('id', 'endic_ext_wrapper')
      .appendTo(document.body);
  
  /**
   * 사전을 연다.
   * @param {object} dicData 사전 데이터
   */
  function open(dicData) {
    if (dicData) {
      console.log(dicData);
      console.log('--', template.getHtml(dicData));
      _$wrapper.html(template.getHtml(dicData));
    }
    
    _$wrapper.show();
  }
 
  /**
   * 사전을 닫는다.
   */
  function close() {
    _$wrapper.hide().empty();
  }

  return {

    open: open, 
    close: close

  };


});
