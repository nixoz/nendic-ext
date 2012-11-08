/**
 * 프레임 관찰자 모듈
 * 
 * 한 페이지에는 여러 프레임이 존재할 수 있다.
 * 페이지가 프레임으로 나뉘어져 있을 수도 있고,
 * 페이지 내에 광고가 포함되어 있을 수도 있다.
 *
 * 영어사전은 페이지 내의 DOM에 사전 엘리먼트를
 * 직접 삽입하는 방식을 사용하고 있으며,
 * 이 때문에, 모든 프레임에 컨텐트 스크립트를 추가해야 한다.
 *
 * 그리고, 모든 프레임에 사전을 보여주는 것은 적합하지 않으므로,
 * 페이지 내 프레임을 탐색해 사전을 띄우기에
 * 가장 적합한 프레임을 찾아내야 한다.
 * 
 * 이 모듈에서는 사용자가 프레임에 마우스를 클릭하는 것을 관찰하고,
 * 프레임에 고유 아이디를 할당하고 사이즈 정보를 알려준다. 
 *
 * @module frameObserver
 * @author ohgyun@gmail.com
 * @version 2012.10.27
 */
define([
  
  'jquery',
  'common/util'
  
], function ($, util) {
  
  var _frameId = util.guid(),
    _activated = false,
    _$doc = $(document);
  
  
  /**
   * 프레임 정보를 가져온다.
   */
  function getInfo() {
    return {
      frameId: _frameId,
      width: _$doc.width(),
      height: _$doc.height()
    };
  }
  
  return {
    /**
     * 현재 프레임의 아이디를 리턴한다.
     */
    getFrameId: function () {
      return _frameId;
    },
    
    /**
     * 현재 프레임 정보를 가져온다.
     * @return {object} info
     *    info.frameId 프레임 고유아이디
     *    info.wframeIdth 프레임 너비
     *    info.height 프레임 높이
     */
    getInfo: function () {
      return getInfo();
    },

    /**
     * 프레임을 활성화한다.
     * @param {string} activatableId 활성화 대상 프레임 아이디
     */
    activate: function (activatableId) {
      _activated = _frameId === activatableId;
    },

    /**
     * 프레임이 활성화되어 있는가?
     */
    isActivated: function () {
      return _activated;
    }
  };

});
