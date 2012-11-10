/**
 * 사전 뷰어 모듈
 *
 * @author ohgyun@gmail.com
 * @version 2012.11.08
 */
define([

  'jquery',
  'cscript/viewer/template',
  'cscript/viewer/action',
  'cscript/viewer/shortcut'

], function ($, template, action, shortcut) {

  var _isOpened = false,
    // 사전을 표시할 래퍼 엘리먼트
    _$wrapper = $('<div>')
      .attr('id', 'endic_ext_wrapper')
      .appendTo(document.body);


  // 뷰어는 사전을 열고 닫는 것만 처리한다.
  // 실제 액션은 action 객체에 위임하며,
  // 뷰어가 초기화될 때 액션 객체도 초기화해준다.
  action.init(_$wrapper);

  // 이벤트를 바인딩한다.
  _$wrapper.on('click', '[data-cmd]', function (e) {
    // 템플릿에서 이벤트를 바인딩할 엘리먼트는,
    // data-cmd 속성에 명령어를,
    // data-cmdval 속성에 전달할 값을 설정한다.
    // viewer 외부에서 setHandler(cmd, handler)를 호출해
    // 각 명령에 대한 콜백을 설정할 수 있다.
    var t = $(this),
      cmd = t.data('cmd'),
      value = t.data('cmdval');

    action.doAction(cmd, value);

    e.preventDefault();
  });
  
  
  // 단축키 이벤트를 바인딩한다.
  shortcut.on('esc', function () {
    close();
  }, function () {
    return _isOpened;
  });

  // 액션에 정의된 단축키를 가져와 할당한다.
  var shortcutMap = action.getShortcutMap();
  for (var key in shortcutMap) {
    (function (k) {
      shortcut.on(k, function () {
        var cmd = shortcutMap[k];
        action.doAction(cmd);
      }, function () {
        return _isOpened;
      });
    }(key));
  }

  /**
   * 사전을 연다.
   * @param {object} dicData 사전 데이터
   */
  function open(dicData) {
    if (dicData) {
      _$wrapper.html(template.getHtml(dicData));
    }
    
    _$wrapper.show();
    _isOpened = true;
  }
 
  /**
   * 사전을 닫는다.
   */
  function close() {
    if (_isOpened) {
      _$wrapper.hide().empty();
      _isOpened = false;
    }
  }

  return {

    open: open, 
    close: close,
   
    hasElement: function (el) {
      return _$wrapper.has(el).length > 0;
    },

    /**
     * 액션 핸들러를 할당한다.
     */
    onAction: function (cmd, callback) {
      action.on(cmd, callback);
    }

  };


});
