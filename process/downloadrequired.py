import tarfile
import urllib2
import mechanize
import os

import shutil


def download_twrp(twrp_link, filename, platform):
    if platform == "win32":
        path = "TWRP\\"
    else:
        path = "TWRP/"
    print("Starting TWRP download")

    br = mechanize.Browser()
    response = br.open(twrp_link + ".html")
    req = br.click_link(url=twrp_link)
    br.open(req)
    file = path + filename
    with open(file, 'wb') as f:
        f.write(br.response().read())


def download_nethunter(nethunter_link, platform):
    if platform == "win32":
        path = "nhzip\\"
    else:
        path = "nhzip/"
    print("Starting Nethunter download")
    download_progress_bar(nethunter_link, path)


def download_factory(factory_link, filename, platform):
    if platform == "win32":
        path = "factory\\"
    else:
        path = "factory/"
    print("Starting factory download")
    filename = path + filename
    download_progress_bar(factory_link, path)
    untar_tgz(filename, platform)


def untar_tgz(filename, platform):

    print("Starting extraction")

    if platform == "win32":
        path = "tmp\\"
    else:
        path = "tmp/"

    if os.path.exists(path):
        print("Found previous folder, removing")
        shutil.rmtree(path)

    if not os.path.exists(path):
        os.makedirs(path)

    tar = tarfile.open(filename, "r:gz")

    for member in tar.getmembers():
        if not member.isdir():  # Skip folders, we only want files
            member.name = os.path.basename(member.name)
            tar.extract(member, path)


def download_progress_bar(url, path):
    try:
        file_name = url.split('/')[-1]
        file_name = path + file_name
        print "DEBUG: " + file_name

        u = urllib2.urlopen(url)
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
    except IOError as e:
       print(e)
    except urllib2.URLError as e:
        print(e)
    except urllib2.HTTPError, e:
        print('HTTPError = ' + str(e.code))
    except Exception:
        print 'generic exception'

def check_for_files(twrp_filename, nethunter_filename, factory_filename, platform):

    if platform == "win32":
        factory_path = "factory\\"
        nh_path = "nhzip\\"
        twrp_path = "TWRP\\"
        supersu_path = "supersu\\supersu.zip"
    else:
        factory_path = "factory/"
        nh_path = "nhzip/"
        twrp_path = "TWRP/"
        supersu_path = "supersu/supersu.zip"

    twrp = False
    nethunter = False
    factory = False
    supersu = False

    twrp_filename = twrp_path + twrp_filename
    nethunter_filename = nh_path + nethunter_filename
    factory_filename = factory_path + factory_filename

    if os.path.exists(twrp_filename):
        twrp = True
    if os.path.exists(nethunter_filename):
        nethunter = True
    if os.path.exists(factory_filename):
        factory = True
    if os.path.exists(supersu_path):
        supersu = True

    return twrp, nethunter, factory, supersu
