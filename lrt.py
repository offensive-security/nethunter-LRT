import json
import urllib2
import os

from process.OEMUnlock import oem_unlock

try:
    url = urllib2.urlopen("https://images.offensive-security.com/nethunter-lrt.json")
    json_data = json.load(url)
except urllib2.HTTPError, e:
    print('HTTPError = ' + str(e.code))
    print("Could not connect with official json file, using local one")
    with open('nethunter-lrt.json') as data_file:
        json_data = json.load(data_file)
    pass

class DeviceVersion:
    def __init__(self, new_dic):

        self.version = new_dic["version"]
        self.factory_url = new_dic["factory"]
        self.nethunter_url = new_dic["nethunter"]
        self.twrp_url = new_dic["twrp"]

    def return_version(self):
        return self.version

    def return_factory(self):
        file_name = self.factory_url.split('/')[-1]

        return self.factory_url, file_name

    def return_nethunter(self):
        file_name = self.nethunter_url.split('/')[-1]

        return self.nethunter_url, file_name

    def return_twrp(self):
        file_name = self.twrp_url.split('/')[-1]

        return self.twrp_url, file_name


def download_progress_bar(url):
    try:
        file_name = url.split('/')[-1]
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
       exit(1)
    except urllib2.URLError as e:
        print(e)
        exit(1)


def get_devices():

    device_list = []

    for item in json_data["devices"]:
        device = item.get("device")
        device_list.append(device)

    return device_list


def parse_json(selected_device, platform):
    '''
    Take the selected device and match against json.
    Example output if Nexus 4 is selected:
    {u'device': u'nexus4', u'version': [{u'nethunter': u'http://url'}]}, {u'5.1.1': [{u'factory': u'https://dl.google.com/dl/android/aosp/occam-lmy48t-factory-416938f1.tgz'}, {u'nethunter': u'http://url'}]}], u'twrp': u'https://dl.twrp.me/mako/twrp-2.8.7.0-mako.img'}
    This is returned so it can be more manageable.
    '''
    if platform == "win32":
        os.system('cls')
    else:
        os.system('clear')

    obj_list = []   # Hold values for every object (version number) we create
    i = 1  # Set menu item to 1

    for device in json_data["devices"]:
        json_model = device.get("device")
        if json_model == selected_device:
            twrp_url = device["twrp"]                            # Get TWRP URL
            for dic in device["version"]:
                for version in dic:
                    ver = version                                # Get version number
                    for keys in dic.iteritems():
                        newlist = dic[ver]
                        factory_url = newlist[0]['factory']      # Get Factory url
                        nethunter_url = newlist[1]['nethunter']  # Get Nethunter url
                        newdic = { "version":ver, "factory":factory_url, "nethunter":nethunter_url, "twrp": twrp_url }
                        obj = DeviceVersion(newdic)  # Create a new object for each version
                        obj_list.append(obj)         # Append that object to a list

    print("Select Android OS version to flash\n")
    for x in obj_list:
        version_string = x.return_version()
        print("[%s] %s:  %s" % (i, selected_device, version_string))  # Menu item: [1] Nexus 4: 5.0.1
        i += 1  # Increment menu item by one
    print("\n[0] Exit to main menu\n")
    answer = True
    while answer:
        try:
            menu_choice = int(raw_input("Select version number: "))
            if menu_choice == 0:
                answer = None
            else:
                selection = menu_choice - 1     # Subtract one from selection (list begins at 0)
                if obj_list[selection]:         # If object exists, return that specific object
                    return obj_list[selection]
        except:
            print("Incorrect selection")

    return


def menu(device_list, platform):

    if platform == "win32":
        os.system('cls')
    else:
        os.system('clear')

    i = 1  # Set first menu item to 1

    print("\nKali NetHunter Linux Root Toolkit\n\n")
    for device in device_list:
        print("[%i] %s" % (i, device))  # example: [1] nexus4
        i += 1  # Add 1 for each menu item
    print "\n[0] Exit\n"

    answer = True
    while answer:
        try:
            menu_choice = int(raw_input('Select: '))
            if menu_choice == 0:
                answer = None
            else:
                selection = menu_choice - 1
                selected_device = device_list[selection]
                device_object = parse_json(selected_device, platform)  # Get values for selected device
                if device_object:
                    return device_object
        except:
            print("Incorrect selection")
    exit(1)


def menu2(device_object, platform, adb, fastboot):
    from process.downloadrequired import check_for_files, untar_tgz
    from process.over9000 import over9000, over9001
    from process.downloadrequired import download_twrp, download_nethunter, download_factory

    twrp_url, twrp_filename = device_object.return_twrp()
    nethunter_url, nethunter_filename = device_object.return_nethunter()
    factory_url, factory_filename = device_object.return_factory()

    if platform == "win32":
        factory_path = "tmp\\"
    else:
        factory_path = "tmp/"

    answer = True
    while answer:
        try:
            if platform == "win32":
                os.system('cls')
            else:
                os.system('clear')
            print("* You should folllow steps in order to flash Nethunter *\n\n")
            print("[1] Download required files (factory/nethunter/twrp)")
            print("[2] OEM Unlock (only needed once)")
            print("[3] Flash Factory Images")
            print("[4] Flash TWRP and Nethunter")
            print("\n[0] Exit\n")
            menu_choice = int(raw_input('Select: '))
            if menu_choice == 0:
                answer = None
            if menu_choice == 1:
                try:
                    twrp, nethunter, factory, supersu = check_for_files(twrp_filename, nethunter_filename, factory_filename, platform)
                    if twrp:
                        print('TWRP already found-skipping')
                    else:
                        download_twrp(twrp_url, twrp_filename, platform)
                    if nethunter:
                        print('Nethunter zip already found-skipping')
                    else:
                        download_nethunter(nethunter_url, platform)
                    if factory:
                        print('Factory zip already found-skipping')
                    else:
                        download_factory(factory_url, factory_filename, platform)
                except urllib2.HTTPError, e:
                    print('HTTPError = ' + str(e.code))
                except urllib2.URLError, e:
                    print('URLError = ' + str(e.reason))
                except Exception:
                    print 'generic exception'
            if menu_choice == 2:
                oem_unlock(adb, fastboot)
            if menu_choice == 3:
                twrp, nethunter, factory, supersu = check_for_files(twrp_filename, nethunter_filename, factory_filename, platform)

                # If factory file (tgz) is downloaded but not extracted, extract, and start!
                if factory and not os.path.exists(factory_path):
                    check = factory_path + factory_filename
                    untar_tgz(check, platform)
                    over9000(adb, fastboot, platform)

                # If factory file (tgz) and extracted folder exists, start!
                if factory and os.path.exists(factory_path):
                    print("All files found! Starting flash!")
                    over9000(adb, fastboot, platform)
                elif os.path.exists(factory_path):
                    print("Missing %s but tmp folder found.  Trying anyways." % factory_filename)
                    over9000(adb, fastboot, platform)
                else:
                    # Nothing at all!
                    if not factory or os.path.exists(factory_path):
                        print("Missing %s or %s" % (factory_filename, factory_path))
            if menu_choice == 4:
                twrp, nethunter, factory, supersu = check_for_files(twrp_filename, nethunter_filename, factory_filename, platform)

                # TWRP and Nethunter files found, execute
                if twrp and nethunter and supersu:
                    print("%s and %s found!\nStarting Nethunter install..." % (twrp_filename, nethunter_filename))
                    over9001(adb, fastboot, platform, twrp_filename, nethunter_filename)
                elif not twrp:
                    print("Missing %s!" % twrp_filename)
                elif not nethunter:
                    print("Missing %s!" % nethunter_filename)
                elif not supersu:
                    print("Missing supersu.zip!")
        except:
            print("Incorrect selection")
    exit(1)


def main():

    # First Check for ADB and SuperSU
    from process.prereq import check_ADB, supersu_check, get_Platform
    adb_path, fastboot, ostype = check_ADB(json_data)  # OSTYPE: False for Windows
    supersu_check()
    platform = get_Platform()

    # Menu populated by JSON file
    device_list = get_devices()

    # First menu to select type of device
    device_object = menu(device_list, platform)

    # Second menu populated with device_object (the selected devce and version)
    menu2(device_object, platform, adb_path, fastboot)


if __name__ == '__main__':
    main()