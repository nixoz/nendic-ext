/**
 * 뷰어에서 발생하는 액션을 처리하는 모듈
 *
 * @author ohgyun@gmail.com
 * @version 2012.11.10
 */
define([
  'jquery',
  'cscript/viewer/pronAudio'
], function ($, pronAudio) {

  var _$wrapper,

    // 액션 호출 시 실행할 콜백 목록
    _callbackMap = {},
  
    // 액션 목록
    _actionMap = {

      // 영영/영한 사전을 토글한다.
      toggleDicType: function () {
        runCallback('toggleDicType');
      },

      // 단어 발음 오디오를 재생한다.
      playAudio: function (audioIdx) {
        pronAudio.play(audioIdx);
      },

      // 단축키 가이드를 토글한다.
      toggleShortcutGuide: function () {
        var $guide = $('#endic_ext_shortcut_guide');
        $guide.toggle();
      }

    };

  /**
   * 액션에 할당되어 있는 콜백을 실행한다.
   */
  function runCallback(cmd) {
    var callback = _callbackMap[cmd];

    if (typeof callback === 'function') {
      callback();
    }
  }

  return {
    init: function ($wrapper) {
      _$wrapper = $wrapper;  
    },

    on: function (cmd, callback) {
      _callbackMap[cmd] = callback;
    },

    doAction: function (cmd, value) {
      var action = _actionMap[cmd];

      if (typeof action === 'function') {
        action(value);
      }
    }

  };

});
