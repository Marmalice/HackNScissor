using FMOD.Studio;
using FMODUnity;
using UnityEngine;

public class CharFoley : MonoBehaviour
{
    public string folderPath;

    public void PlaySingleEvent(string eventName)
    {
        EventInstance Sound = RuntimeManager.CreateInstance(folderPath + eventName);

        RuntimeManager.AttachInstanceToGameObject(Sound, gameObject, GetComponent<Rigidbody>());

        Sound.start();
        Sound.release();
    }
}
