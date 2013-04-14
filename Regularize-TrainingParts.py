#!/usr/bin/env python
# encoding: utf-8
import os
import cv2
import os.path
 
hiSize = 10
loSize = 5
colName = 'symbols'

def main():
    dir = 'training\\{0}_raw'.format(colName)
    lodir = 'training\\{0}_lo'.format(colName)
    hidir = 'training\\{0}_hi'.format(colName)

    mkdir(lodir)
    mkdir(hidir);

    files = os.listdir(dir)
    images = filter(lambda x: x.endswith(".png"), files)

    for image in images:
        print image
        source = os.path.join(dir, image)
        targetLo = os.path.join(lodir, image)
        targetHi = os.path.join(hidir, image)
        regularizeImage(source, targetLo, loSize)
        regularizeImage(source, targetHi, hiSize)
    return 0        # success

def regularizeImage(source, target, size):
    image = cv2.imread(source)
    
    if image.shape[0] != image.shape[1]:
        return

    image = cv2.resize(image,(size,size))
    cv2.imwrite(target, image)

def mkdir(path):
    if not os.path.exists(path):
        os.mkdir(path)

if __name__ == '__main__':
    main()
    os.system("pause")
