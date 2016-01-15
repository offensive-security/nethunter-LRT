from distutils.spawn import find_executable  # Check for ADB and fastboot
from sys import platform as _platform        # Check for Linux/OSX
import zipfile                               # Unzip zip files
import os
from lrt import download_progress_bar
import urllib2


class LatestSU:
    def __getPage(self, url, retRedirUrl=False):
        try:
            bOpener = urllib2.build_opener()
            bOpener.addheaders = [("User-agent",
                                   "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.146 Safari/537.36")]
            pResponse = bOpener.open(url)
            if retRedirUrl == True:
                return pResponse.geturl()
            else:
                pageData = pResponse.read()
                return pageData

        except urllib2.HTTPError, e:
            print('HTTPError = ' + str(e.code))
        except urllib2.URLError, e:
            print('URLError = ' + str(e.reason))

    def dlsupersu(self):

        getUrl = self.__getPage('http://download.chainfire.eu/896/SuperSU/BETA-SuperSU-v2.66-20160103015024.zip', True)
        # Stable (release verison)
        # getUrl = self.__getPage('http://download.chainfire.eu/supersu', True)
        latestUrl = getUrl + '?retrieve_file=1'

        return latestUrl


def get_Platform():
    if _platform == "linux" or _platform == "linux2":
      return "linux"
    elif _platform == "darwin":
      return "osx"
    elif _platform == "win32":
      return "win32"


def unzip(source_filename, dest_dir):
    with zipfile.ZipFile(source_filename) as zf:
        for member in zf.infolist():
            # Path traversal defense copied from
            # http://hg.python.org/cpython/file/tip/Lib/http/server.py#l789
            words = member.filename.split('/')
            path = dest_dir
            for word in words[:-1]:
                drive, word = os.path.splitdrive(word)
                head, word = os.path.split(word)
                if word in (os.curdir, os.pardir, ''): continue
                path = os.path.join(path, word)
            zf.extract(member, path)


def supersu_check():

    # Check if this is windows/osx/linux
    platform = get_Platform()

    if platform == "win32":
        suzipfile = 'supersu\\supersu.zip'
    else:
        suzipfile = 'supersu/supersu.zip'

    if os.path.exists(suzipfile):
        print('SuperSU file already downloaded!')
    else:
        ldclass = LatestSU()
        u = urllib2.urlopen(ldclass.dlsupersu())

        # Progress bar http://stackoverflow.com/a/22776
        file_name = os.path.join('supersu', 'supersu.zip')
        f = open(file_name, 'wb')
        meta = u.info()
        file_size = int(meta.getheaders("Content-Length")[0])
        print "Downloading: %s Bytes: %s" % (file_name, file_size)

        file_size_dl = 0
        block_sz = 8192
        while True:
            buffer = u.read(block_sz)
            if not buffer:
                break

            file_size_dl += len(buffer)
            f.write(buffer)
            status = r"%10d  [%3.2f%%]" % (file_size_dl, file_size_dl * 100. / file_size)
            status = status + chr(8)*(len(status)+1)
            print status,
        f.close()


def check_ADB(json_data):

    # Check if this is windows/osx/linux
    platform = get_Platform()
    if platform == "win32":
        opersys = False
    else:
        opersys = True

    try:
        findme_adb = find_executable("adb")
        findme_fastboot = find_executable("fastboot")
        if findme_adb and findme_fastboot:
            # Found ADB and fastboot, check version now
            print("Found ADB and FASTBOOT in path.")
            adb = "adb"
            fastboot = "fastboot"

            return adb, fastboot, opersys
    except:
        pass

    # Define file paths for ADB and fastboot
    adb_unix_path = "tools/platform-tools/platform-tools/adb"
    fastboot_unix_path = "tools/platform-tools/platform-tools/fastboot"
    adb_windows_path = "tools\\platform-tools\\platform-tools\\adb"
    fastboot_windows_path = "tools\\platform-tools\\platform-tools\\fastboot"

    # Check if files exist
    adb_unix = os.path.exists(adb_unix_path)
    fastboot_unix = os.path.exists(fastboot_unix_path)
    adb_windows = os.path.exists(adb_windows_path)
    fastboot_windows = os.path.exists(fastboot_windows_path)

    # Check OS type, download/unzip platform tools, pass file paths
    if platform == "win32":
        if adb_windows and fastboot_windows:
            print("ADB and FASTBOOT found!")
        else:
            windows = json_data['sdk'][0]['windows']
            print('Downloading platform tools for Windows: %s' % windows)
            download_progress_bar(windows)
            print('Unzipping %s' % windows[34:])
            unzip(windows[34:], "tools")

        return adb_windows_path, fastboot_windows_path, opersys

    elif platform == "osx":
        if adb_unix or fastboot_unix:
            print("ADB and FASTBOOT found!")
        else:
            osx = json_data['sdk'][0]['osx']
            print('Downloading platform tools for OSX: %s' % osx)
            download_progress_bar(osx)
            print('Unzipping %s' % osx[34:])
            unzip(osx[34:], "tools")
            os.system("chmod 755 " + adb_unix_path)
            os.system("chmod 755 " + fastboot_unix_path)

        return adb_unix_path, fastboot_unix_path, opersys

    elif platform == "linux":
        if adb_unix or fastboot_unix:
            print("ADB and FASTBOOT found!")
        else:
            linux = json_data['sdk'][0]['linux']
            print('Downloading platform tools for Linux: %s' % linux)
            download_progress_bar(linux)
            print('Unzipping %s' % linux[34:])
            unzip(linux[34:], "tools")
            os.system("chmod 755 " + adb_unix_path)
            os.system("chmod 755 " + fastboot_unix_path)

        return adb_unix_path, fastboot_unix_path, opersys