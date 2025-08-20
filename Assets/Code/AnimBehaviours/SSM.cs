using System.Collections;
using UnityEngine;
using UnityEngine.InputSystem.Interactions;

public class SSM : StateMachineBehaviour
{
    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    //override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    
    //}

    // OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
    //override public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    
    //}

    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    //override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    
    //}

    // OnStateMove is called right after Animator.OnAnimatorMove()
    //override public void OnStateMove(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    // Implement code that processes and affects root motion
    //}

    // OnStateIK is called right after Animator.OnAnimatorIK()
    //override public void OnStateIK(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    // Implement code that sets up animation IK (inverse kinematics)
    //}
    private Character character;
    void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo)
    {
        character = animator.GetComponent<Character>();
        if (pingOrient)
        {
            character.UpdateDirection();
        }

        character.StateSwap();
        character.CanCancelState(canCancel ? 1 : 0);
        character.canTurn = canOrient;
    }

    public bool canOrient = true;
    public bool pingOrient = false;
    public bool canCancel = false;
}
