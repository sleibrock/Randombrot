#!/usr/bin/env python
#-*- coding: utf-8 -*-

"""
Upload a file to Twitter
Reads a file for keys to use with OAuth
Uploads a file in the current directory
"""
import tweepy
from sys import argv

def read_keys(fname="keys.txt"):
    """
    Read the keys from the local key file
    """
    try:
        with open(fname, "r") as f:
            lines = [l.strip("\n") for l in f.readlines()] 
        return lines
    except Exception as e:
        print("Error: {}".format(e))
        quit()
    return list()

def create_api(key_lines=[]):
    """
    Create the Twitter API from a list of key lines
    """
    if not key_lines:
        raise Exception("No keys given")
    auth = tweepy.OAuthHandler(key_lines[0], key_lines[1])
    auth.set_access_token(key_lines[2], key_lines[3])
    return tweepy.API(auth)

def main(*args, **kwargs):
    """
    Upload a file to a Twitter account
    """
    argv.pop(0)
    status = str()
    if argv:
        status = argv.pop()
    unuploaded = True
    while unuploaded:
        try:
            api = create_api(read_keys())
            api.update_with_media("output.png", status)
            unuploaded = False
            print("Successfully uploaded!")
        except Exception as e:
            print("Error: {}".format(e))

if __name__ == "__main__":
    main()
