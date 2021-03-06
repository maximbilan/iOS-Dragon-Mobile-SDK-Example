# Nuance Dragon Mobile SDK and ObjectAL

In <i>iOS 8</i> I’m faced with a problem with working <a href="http://dragonmobile.nuancemobiledeveloper.com/public/index.php?task=prodDev#download">Nuance Dragon Mobile SDK</a> and <a href="https://github.com/kstenerud/ObjectAL-for-iPhone">ObjectAL</a> together. When I set up <a href="http://dragonmobile.nuancemobiledeveloper.com/public/index.php?task=prodDev#download">Nuance SDK</a>, and if I already have used the <a href="https://github.com/kstenerud/ObjectAL-for-iPhone">ObjectAL</a> before, I have got the error in the log:

<pre>
ERROR:     [0x3c1779dc] AVAudioSession.mm:646: -[AVAudioSession setActive:withOptions:error:]: 
Deactivating an audio session that has running I/O. All I/O should be stopped or paused prior
to deactivating the audio session.
</pre>

And I can’t play or record an audio, because session was deactivated in the application.

What does it mean? It means that <a href="http://dragonmobile.nuancemobiledeveloper.com/public/index.php?task=prodDev#download">Nuance SDK</a> tries to set up the active session, and you have some sessions in the <a href="https://github.com/kstenerud/ObjectAL-for-iPhone">ObjectAL</a>.

<i>iOS 8</i> provides some information about this. In <i>AVAudioSession</i> header:

<pre>
/* Set the session active or inactive. Note that activating an audio session is a synchronous
(blocking) operation. Therefore, we recommend that applications not activate their session from
a thread where a long blocking operation will be problematic.
Note that this method will throw an exception in apps linked on or after iOS 8 if the session is
set inactive while it has running or paused I/O (e.g. audio queues, players, recorders,
converters, remote I/Os, etc.).
*/
</pre>

And unfortunately <a href="http://dragonmobile.nuancemobiledeveloper.com/public/index.php?task=prodDev#download">Nuance SDK</a> is private API. And we don’t have access to the source code ☹

You can found some post in the official forum of this SDK. And there’re no any solutions. And the Nuance team did not particularly hurry to solve this issue ☹

But, it’s not all bad. Because we have <a href="https://github.com/kstenerud/ObjectAL-for-iPhone">ObjectAL</a> with opened source code ☺ And I can suggest the solution, maybe it’s not really good solution, but it works. Before using the <a href="http://dragonmobile.nuancemobiledeveloper.com/public/index.php?task=prodDev#download">Nuance SDK</a> you remove the <a href="https://github.com/kstenerud/ObjectAL-for-iPhone">ObjectAL</a> from memory, wait for deallocating framework, and will set up the <a href="http://dragonmobile.nuancemobiledeveloper.com/public/index.php?task=prodDev#download">Nuance SDK</a> after that. During the recognition you should not use <a href="https://github.com/kstenerud/ObjectAL-for-iPhone">ObjectAL</a>, because it’s will deactivate the audio session, but you can use for example <i>AVAudioPlayer</i>.

For stop the <a href="https://github.com/kstenerud/ObjectAL-for-iPhone">ObjectAL</a> you should call the next:

<pre>
[[OALSimpleAudio sharedInstance] stopEverything];
[OALSimpleAudio purgeSharedInstance];
</pre>

If you play some audios during the recognition, you should no forgot to stop the playing audio in the <i>didFinishWithResults</i> and <i>didFinishWithError</i> methods, for example for <i>AVAudioPlayer</i>:

<pre>
- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results
{
    if (audioPlayer) {
        [audioPlayer stop];
    }

    ...
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error
        suggestion:(NSString *)suggestion
{
    if (audioPlayer) {
        [audioPlayer stop];
    }

    ...
}
</pre>

You can check and try this in current repository.<br>
It’s modified sample from <a href="http://dragonmobile.nuancemobiledeveloper.com/public/index.php?task=prodDev#download">Nuance SDK</a>.
