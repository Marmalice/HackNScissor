
using System;
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerRM : Character
{
    //References
    [SerializeField] private Transform cam;
    [SerializeField] private Transform camorigin;
    [SerializeField] private float camDist = 7;
    [SerializeField] private float sensitivity = .7f;
    [SerializeField] protected int MaxCombo = 2;
    [SerializeField] private GameObject swappedCharacter;
    private AggroManager aggroManager;

    //Camera Stuff
    private Vector2 inputDir = Vector2.zero;
    private Vector2 look = Vector2.zero;
    private Vector2 lookDir;
    private Transform camholder;
    private Transform lockTarget = null;

    //Input
    private BufferedInput buffer = BufferedInput.Empty;
    // These can be used later to make charge attacks happen
    // private bool M1Down = false;
    // private bool M2Down = false;
    private bool dodgeDown = false;

    //Numbers to keep track of
    private LayerMask charMask;
    private Vector3 forward = Vector3.zero;
    private Vector3 right = Vector3.zero;
    private Vector3 dirToEnemy = Vector3.zero;
    protected int comboState = 0;

    void Awake()
    {
        animator = GetComponent<Animator>();
        comboState = MaxCombo + 1;
        controller = GetComponent<CharacterController>();
        camholder = cam.parent;
        camholder.parent = null;
        charMask = LayerMask.GetMask("Characters");
        Cursor.lockState = CursorLockMode.Locked;
    }

    private void Start()
    {
        SetupCharacter();
    }

    void OnEnable()
    {
        Vector3 camEulers = camholder.rotation.eulerAngles;
        lookDir = new Vector2(camEulers.y, camEulers.x);
        try
        {
            AggroManager.aggroManager.ReregisterPlayer(gameObject);
        }
        catch
        {
            Debug.LogWarning("Bandaid Fix Invoked");
        }
    }

    public void EndCombo()
    {
        comboState = MaxCombo + 1;
    }

    void Update()
    {
        Move();
        Look();
        Cancels();
        
        //Temporary Solution
        controller.Move(Vector3.down);
    }

    void OnAnimatorMove()
    {
        Vector3 velocity = animator.deltaPosition;

        controller.Move(velocity);
    }

    public void OnMove(InputValue value)
    {
        inputDir = value.Get<Vector2>();
    }

    public void OnLook(InputValue value)
    {
        look = value.Get<Vector2>();
    }

    public void OnM1(InputValue value)
    {
        if (value.Get<float>() > .5f)
        {
            //M1Down = true;
        }
        else
        {
            //M1Down = false;
        }

        if (value.isPressed)
        {
            //On Press M1
            buffer = BufferedInput.Sweep;
        }
    }

    public void OnM2(InputValue value)
    {
        if (value.Get<float>() > .5f)
        {
            //M2Down = true;
        }
        else
        {
            //M2Down = false;
        }

        if (value.isPressed)
        {
            //On Press M2
            buffer = BufferedInput.Thrust;
        }
    }

    public void OnDodge(InputValue value)
    {
        if (value.Get<float>() > .5f)
        {
            dodgeDown = true;
            animator.SetBool("Sprint", true);
        }
        else
        {
            dodgeDown = false;
            animator.SetBool("Sprint", false);
        }

        if (value.isPressed)
        {
            //On Press Dodge
            buffer = BufferedInput.Dodge;
        }
    }

    public void OnInteract(InputValue value)
    {
        if (value.isPressed)
        {
            //On Press Swap
            StartTransform();
        }
    }

    public void OnLock(InputValue value)
    {
        if (value.isPressed)
        {
            //On Press Lock
            LockCamera();
        }
    }

    private void LockCamera()
    {
        if (lockTarget != null)
        {
            lockTarget = null;
            Vector3 camEulers = camholder.rotation.eulerAngles;
            lookDir = new Vector2(camEulers.y, camEulers.x);
        }
        else
        {
            //Get all enemies
            //Find most screen center
            //Give to container and turn on
            float newDot;
            float currentHighest = .5f;
            Transform currentTarget = null;

            foreach (Character character in AggroManager.aggroManager.targetables)
            {
                dirToEnemy = Vector3.Normalize(character.transform.position - transform.position);
                newDot = Vector3.Dot(dirToEnemy, camholder.forward);

                if (newDot > currentHighest)
                {
                    currentHighest = newDot;
                    currentTarget = character.transform;
                }
            }
            lockTarget = currentTarget;
        }
    }

    private void StartTransform()
    {
        swappedCharacter.transform.position = transform.position;
        swappedCharacter.transform.rotation = transform.rotation;
        animator.SetTrigger("StartTransform");
    }

    public void SwapCharacters()
    {
        lockTarget = null;
        swappedCharacter.SetActive(true);
        gameObject.SetActive(false);
    }

    private void Look()
    {
        camholder.position = Vector3.Lerp(camholder.position,camorigin.position,.02f);

        lookDir.y -= look.y * sensitivity;
        lookDir.x += look.x * sensitivity;
        lookDir.y = Mathf.Clamp(lookDir.y, -90, 90);

        if (lockTarget == null)
        {
            camholder.rotation = Quaternion.Euler(new Vector3(lookDir.y, lookDir.x, 0));
        }
        else
        {
            dirToEnemy = lockTarget.position - camholder.position;

            if (dirToEnemy.magnitude > 30)
            {
                LockCamera();
            }
            else
            {
                camholder.rotation = Quaternion.RotateTowards(camholder.rotation, Quaternion.LookRotation(dirToEnemy), Time.deltaTime * 200);
            }
        }

        RaycastHit camhit;

        if (Physics.Raycast(camholder.transform.position, cam.transform.forward * -1, out camhit, camDist, ~charMask))
        {
            float dot = Vector3.Dot(cam.transform.forward, camhit.normal);
            cam.transform.localPosition = new Vector3(0, 0, -camhit.distance + Mathf.Lerp(.5f, 0, dot));
        }
        else
        {
            cam.transform.localPosition = new Vector3(0, 0, -1f * camDist + .5f);
        }
    }

    private void Move()
    {
        forward = camholder.transform.forward;
        forward.y = 0;
        forward.Normalize();

        right = camholder.transform.right;
        right.y = 0;
        right.Normalize();

        wishDir = forward * inputDir.y + right * inputDir.x;
        
        if (wishDir.magnitude > .1f)
        {
            animator.SetBool("Run", true);
        }
        else
        {
            animator.SetBool("Run", false);
        }

        if (canTurn && wishDir.magnitude > .1f)
            transform.rotation = Quaternion.RotateTowards(transform.rotation, Quaternion.LookRotation(wishDir), Time.deltaTime * 600);
    }

    private void Cancels()
    {
        if (canCancel)
        {
            switch (buffer.GetHashCode())
            {
                case 0:
                    animator.SetTrigger("Dodge");
                    break;
                case 1:
                    ProgressCombo(1);

                    // if (comboState > 2)
                    // animator.SetInteger("Attack", 3);
                    // else
                    // animator.SetInteger("Attack", 1);
                    break;
                case 2:
                    ProgressCombo(2);

                    // if (comboState > 2)
                    // animator.SetInteger("Attack", 4);
                    // else
                    // animator.SetInteger("Attack", 2);
                    break;
            }

            buffer = BufferedInput.Empty;
        }
    }

    private void ProgressCombo(int chain)
    {
        if (comboState > MaxCombo || comboState % 2 == chain - 1)
        {
            comboState = chain;
        }

        animator.SetInteger("AttackChoice", comboState);
        comboState += 2;

        // if (comboState % 2 != chain - 1)
        // {
        //     animator.SetInteger("Attack", comboState);
        //     comboState += 2;
        //     return;
        // }

        // comboState = chain;
        // animator.SetInteger("Attack", comboState);
    }

    public void ResetCombo()
    {
        comboState = MaxCombo + 1;
    }

    public override void RegisterHit()
    {
        if (!invulnerable)
        {
            animator.Play("Hit");
        }
    }

    public override void OnEnterAnimState()
    {
        buffer = BufferedInput.Empty;
    }

    public override void OnExitAnimState(string behaviour)
    {
    }
}

public enum BufferedInput
{
    Empty = -1,
    Dodge = 0,
    Sweep = 1,
    Thrust = 2
}