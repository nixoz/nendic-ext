/**
 * 프레임 관리자
 *
 * 도큐먼트 내에는 iframe을 포함해 여러 프레임이 존재하기 때문에,
 * 영어사전을 표시하기에 가장 적합한 프레임을 찾아서 보여줘야 한다.
 * 이 모듈에서는, 각 탭 별 프레임들의 사이즈를 저장하고,
 * 요청 시 적합한 프레임을 찾아주는 역할을 한다.
 * 
 * @module frameManager
 * @author ohgyun@gmail.com
 * @version 2012.10.27
 */
define([

], function () {
  
  var
    /**
     * currentMap (object)
     *   tabId (string): frames (object)
     *   
     * frames
     *   activated (object) activated frame data
     *   list (array) current frame list
     *   
     * activated
     *   id (string) frame id
     *   width (string) frame width
     *   height (string) frame height
     */
    _map = {};
    
    
  /**
   * try to set data of current frame
   * 
   * @param data (object)
   *   id (string) frame id
   *   width (string) frame width
   *   height (string) frame height
   * @param tabId (string)
   */
  function initFrame(data, tabId) {
    var frames = _map[tabId];
    
    // 프레임 정보가 없다면 생성한다.
    if ( ! frames) {
      _map[tabId] = frames = {
        activated: null,
        list: []
      };
    }
    
    // 프레임 목록에 추가한다.
    frames.list.push(data.id);
    
    // 활성화할 프레임을 결정한다.
    if (frames.activated) {
      var currentSize = frames.activated.width * frames.activated.height,
        newSize = data.width * data.height;
      
      // 어떤 것을 활성화할 지는 프레임의 크기로 결정한다.
      if (newSize > currentSize) {
        frames.activated = data;
      }
      
    } else {
      // 활성화되어 있는 프레임이 없다면, 현재 것으로 설정한다.
      frames.activated = data;
    }
    
    
    chrome.tabs.sendRequest(tabId, {
      "command": "frameActivated",
      "data": frames.activated.id
    });
    
  }
  
  /**
   * 현재 프레임이 존재하지 않으면, 프레임을 리셋한다.
   */
  function checkFrameExist(data, tabId) {
    var frameId = data;
    
    if (isNotExist(frameId, tabId)) {
      resetFrame(tabId);
    }
  }
  
  /**
   * 탭 내 프레임 목록에 요청한 프레임 아이디가 존재하는지 확인한다.
   */
  function isNotExist(frameId, tabId) {
    var frames = _map[tabId];
    
    if ( ! frames) { return true; }
    
    var frameList = frames.list;
    
    for (var i = 0, len = frameList.length; i < len; i++) {
      if (frameList[i] === frameId) {
        return false;
      }
    }
    
    return true;
  }
  
  /**
   * 프레임 정보를 리셋하고, 컨텐츠에 프레임 정보 초기화 메세지를 보낸다.
   */
  function resetFrame(tabId) {
    delete _map[tabId];
    
    chrome.tabs.sendRequest(tabId, {
      "command": "needFrameInfo"
    }); 
  }
  
  return {
    
  };
  
});