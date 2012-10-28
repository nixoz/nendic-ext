/**
 * 프레임 관찰자 모듈
 * 
 * @module frameObserver
 * @author ohgyun@gmail.com
 * @version 2012.10.27
 */
require([
  
  'jquery',
  'common/util'
  
], function ($, util) {
  
  var _guid = util.guid();
  
  
  /**
   * 프레임을 관찰할 이벤트를 등록한다.
   */
  function registerFrameActivateEvent() {
    $(document).mousedown(function (e) {
      console.log('e')
    });  
  }
  
  
  
});