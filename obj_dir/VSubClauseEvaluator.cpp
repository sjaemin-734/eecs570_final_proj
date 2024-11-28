// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See VSubClauseEvaluator.h for the primary calling header

#include "VSubClauseEvaluator.h"
#include "VSubClauseEvaluator__Syms.h"

//==========

void VSubClauseEvaluator::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate VSubClauseEvaluator::eval\n"); );
    VSubClauseEvaluator__Syms* __restrict vlSymsp = this->__VlSymsp;  // Setup global symbol table
    VSubClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
#ifdef VL_DEBUG
    // Debug assertions
    _eval_debug_assertions();
#endif  // VL_DEBUG
    // Initialize
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) _eval_initial_loop(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Clock loop\n"););
        vlSymsp->__Vm_activity = true;
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("SubClauseEvaluator.sv", 1, "",
                "Verilated model didn't converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

void VSubClauseEvaluator::_eval_initial_loop(VSubClauseEvaluator__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    _eval_initial(vlSymsp);
    vlSymsp->__Vm_activity = true;
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        _eval_settle(vlSymsp);
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("SubClauseEvaluator.sv", 1, "",
                "Verilated model didn't DC converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

VL_INLINE_OPT void VSubClauseEvaluator::_combo__TOP__1(VSubClauseEvaluator__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSubClauseEvaluator::_combo__TOP__1\n"); );
    VSubClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->SubClauseEvaluator__DOT__var_indices[0U] 
        = vlTOPp->var1;
    vlTOPp->SubClauseEvaluator__DOT__var_indices[1U] 
        = vlTOPp->var2;
    vlTOPp->SubClauseEvaluator__DOT__var_indices[2U] 
        = vlTOPp->var3;
    vlTOPp->SubClauseEvaluator__DOT__var_indices[3U] 
        = vlTOPp->var4;
    vlTOPp->SubClauseEvaluator__DOT__var_indices[4U] 
        = vlTOPp->var5;
    vlTOPp->SubClauseEvaluator__DOT__partial_sat_eval__DOT__eval_result 
        = (((IData)(vlTOPp->clause_mask) & (~ (IData)(vlTOPp->unassign))) 
           & ((IData)(vlTOPp->assignment) ^ (IData)(vlTOPp->clause_pole)));
    vlTOPp->__Vtableidx1 = ((IData)(vlTOPp->clause_mask) 
                            & (IData)(vlTOPp->unassign));
    vlTOPp->SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position 
        = vlTOPp->__Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position
        [vlTOPp->__Vtableidx1];
    vlTOPp->SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit 
        = vlTOPp->__Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit
        [vlTOPp->__Vtableidx1];
    vlTOPp->unit_clause = ((IData)(vlTOPp->SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit) 
                           & (~ (IData)((0U != (IData)(vlTOPp->SubClauseEvaluator__DOT__partial_sat_eval__DOT__eval_result)))));
    vlTOPp->new_assignment = (1U & ((~ ((4U >= (IData)(vlTOPp->SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position)) 
                                        & ((IData)(vlTOPp->clause_pole) 
                                           >> (IData)(vlTOPp->SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position)))) 
                                    & (~ (IData)((0U 
                                                  != (IData)(vlTOPp->SubClauseEvaluator__DOT__partial_sat_eval__DOT__eval_result))))));
    vlTOPp->implied_variable = (((IData)(vlTOPp->SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit) 
                                 & (~ (IData)((0U != (IData)(vlTOPp->SubClauseEvaluator__DOT__partial_sat_eval__DOT__eval_result)))))
                                 ? ((4U >= (IData)(vlTOPp->SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position))
                                     ? vlTOPp->SubClauseEvaluator__DOT__var_indices
                                    [vlTOPp->SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position]
                                     : 0U) : 0U);
}

void VSubClauseEvaluator::_eval(VSubClauseEvaluator__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSubClauseEvaluator::_eval\n"); );
    VSubClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_combo__TOP__1(vlSymsp);
    vlTOPp->__Vm_traceActivity[1U] = 1U;
}

VL_INLINE_OPT QData VSubClauseEvaluator::_change_request(VSubClauseEvaluator__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSubClauseEvaluator::_change_request\n"); );
    VSubClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    return (vlTOPp->_change_request_1(vlSymsp));
}

VL_INLINE_OPT QData VSubClauseEvaluator::_change_request_1(VSubClauseEvaluator__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSubClauseEvaluator::_change_request_1\n"); );
    VSubClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // Change detection
    QData __req = false;  // Logically a bool
    return __req;
}

#ifdef VL_DEBUG
void VSubClauseEvaluator::_eval_debug_assertions() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSubClauseEvaluator::_eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((clause_mask & 0xe0U))) {
        Verilated::overWidthError("clause_mask");}
    if (VL_UNLIKELY((unassign & 0xe0U))) {
        Verilated::overWidthError("unassign");}
    if (VL_UNLIKELY((assignment & 0xe0U))) {
        Verilated::overWidthError("assignment");}
    if (VL_UNLIKELY((clause_pole & 0xe0U))) {
        Verilated::overWidthError("clause_pole");}
    if (VL_UNLIKELY((var1 & 0xfe00U))) {
        Verilated::overWidthError("var1");}
    if (VL_UNLIKELY((var2 & 0xfe00U))) {
        Verilated::overWidthError("var2");}
    if (VL_UNLIKELY((var3 & 0xfe00U))) {
        Verilated::overWidthError("var3");}
    if (VL_UNLIKELY((var4 & 0xfe00U))) {
        Verilated::overWidthError("var4");}
    if (VL_UNLIKELY((var5 & 0xfe00U))) {
        Verilated::overWidthError("var5");}
}
#endif  // VL_DEBUG
