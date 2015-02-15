# Nuance Dragon Mobile SDK and ObjectAL

In iOS 8 I’m faced with a problem with working Nuance Dragon Mobile SDK and ObjectAL together. When I set up Nuance SDK, and if I already have used the ObjectAL before, I have got a error in the log:

<pre>
ERROR:     [0x3c1779dc] AVAudioSession.mm:646: -[AVAudioSession setActive:withOptions:error:]: Deactivating an audio session that has running I/O. All I/O should be stopped or paused prior to deactivating the audio session.
</pre>

And I can’t play or record audio, because session was deactivated in the application.

What does it mean? It means that Nuance SDK tries to set up active session, and you have some sessions in the ObjectAL.

iOS 8 provides some information about this. In AVAudioSession header:

<pre>
/* Set the session active or inactive. Note that activating an audio session is a synchronous (blocking) operation.
Therefore, we recommend that applications not activate their session from a thread where a long blocking operation will be problematic.
Note that this method will throw an exception in apps linked on or after iOS 8 if the session is set inactive while it has running or paused I/O (e.g. audio queues, players, recorders, converters, remote I/Os, etc.).
*/
</pre>

And unfortunately Nuance SDK is private API. And we don’t have access to the source code ☹

You can found some post in the official forum of this SDK. And there’re no any solutions. And the Nuance team did not particularly hurry to solve this issue ☹

But, it’s not all bad. Because we have ObjectAL with opened source code☺And I can suggest the solution, maybe it’s not really good solution, but it works. Before using the Nuance SDK you remove the ObjectAL from memory, wait for deallocating framework, and will set up the Nuance SDK after that. During the recognition you should not use ObjectAL, because it’s will deactivate the audio session, but you can use for example AVAudioPlayer.

For stop the ObjectAL you should call the next:

<pre>
[[OALSimpleAudio sharedInstance] stopEverything];
[OALSimpleAudio purgeSharedInstance];
</pre>

If you play some audios during the recognition, you should no forgot stop the playing audio in the didFinishWithResults and didFinishWithError methods, for example for AVAudioPlayer:

<pre>
- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results
{
    if (audioPlayer) {
        [audioPlayer stop];
    }

    ...
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion
{
    if (audioPlayer) {
        [audioPlayer stop];
    }

    ...
}
</pre>

You can check and try this in my github. It’s modified sample from Nuance SDK.
