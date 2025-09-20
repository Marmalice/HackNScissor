using UnityEngine;
using System;

[CreateAssetMenu(fileName = "Attack", menuName = "Behaviour/Attack")]
public class Attack : BehaviourAction
{

    // protected override void InitializeAction(BehaviourCharacter character)
    // {
    //     character.AttackEnd.AddListener(() => AttackComplete(character));
    // }

    public override void EndAction(BehaviourCharacter character, ActionContext context)
    {

    }

    public override void StartAction(BehaviourCharacter character, ActionContext context)
    {
        if (context is AttackVars vars)
        {
            if (vars.attackIndex != 0)
            {
                character.animator.SetInteger("AttackChoice", vars.attackIndex);
            }

            character.animator.SetTrigger("Attack");
        }
    }

    private void AttackComplete(BehaviourCharacter character, ActionContext context)
    {
        if (context is AttackVars vars)
        {
            if (!vars.interrupted)
            {
                //Debug.Log("Atk Complete");
                //character.ChangeAction();
            }
        }
    }
    public override void UpdateAction(BehaviourCharacter character, ActionContext context)
    {
        if (character.canTurn)
        {
            character.RotateToTarget();
        }
    }

    public override ActionContext ActionContext()
    {
        return CreateInstance<AttackVars>();
    }
}

