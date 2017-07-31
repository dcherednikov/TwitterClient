# TwitterClient
A simple twitter client that mocks some of Twitter's key features.

To run the app succesfully, create your own app at https://apps.twitter.com, set it's access level
to 'Read, write, and direct messages' and copy-paste your Consumer Key, Consumer Secret, Access Token and Access Token Secret
into the Keychain.plist file.

You also need to add STTwitter as a dependency by simply adding this line to your Podfile:

pod 'STTwitter'

and running "pod install" in the Terminal.
