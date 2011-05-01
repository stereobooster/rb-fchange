require 'win32/api'

module FChange
  # This module contains the low-level foreign-function.
  # It's an implementation detail, and not meant for users to deal with.
  #
  # @private
  module Native

    #
    INFINITE = 0xFFFFFFFF

    #
    WAIT_OBJECT_0 = 0x00000000
      
    # HANDLE FindFirstChangeNotification(
    #  LPCTSTR lpPathName,    // directory name
    #  BOOL bWatchSubtree,    // monitoring option
    #  DWORD dwNotifyFilter   // filter conditions
    #);
    @_k32FindFirstChangeNotification = 
      Win32::API.new('FindFirstChangeNotification', ['P', 'I', 'L'], 'L')

    # @return handle
    def k32FindFirstChangeNotification(path, recursive, flag)
        @_k32FindFirstChangeNotification.call(path, recursive ? 1 : 0, flag)
    end
    
    module_function "k32FindFirstChangeNotification"
    
    # BOOL FindNextChangeNotification(
    #  HANDLE hChangeHandle   // handle to change notification
    # );
    @_k32FindNextChangeNotification = 
      Win32::API.new('FindNextChangeNotification', ['L'], 'I')
    
    def k32FindNextChangeNotification(handle)
        @_k32FindNextChangeNotification.call(handle)
    end
    
    module_function "k32FindNextChangeNotification"

    # DWORD WaitForMultipleObjects(
    #   DWORD nCount,             // number of handles in array
    #   CONST HANDLE *lpHandles,  // object-handle array
    #   BOOL bWaitAll,            // wait option
    #   DWORD dwMilliseconds      // time-out interval
    # );
    @_k32WaitForMultipleObjects = 
      Win32::API.new('WaitForMultipleObjects', ['L', 'P', 'I', 'L'], 'L')
    
    def k32WaitForMultipleObjects(count, handles, wait_all, time)
        @_k32WaitForMultipleObjects.call(count, handles, wait_all, time)
    end
    
    module_function "k32WaitForMultipleObjects"

    # BOOL FindCloseChangeNotification(
    #   HANDLE hChangeHandle
    # );
    @_k32FindCloseChangeNotification = 
      Win32::API.new('FindCloseChangeNotification', ['L'], 'I')

    def k32FindCloseChangeNotification(handle)
        @_k32FindCloseChangeNotification.call(handle)
    end
    
    module_function "k32FindCloseChangeNotification"
  end
end
