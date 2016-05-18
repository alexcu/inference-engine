Assignment details:

    Assignment 2 - Inference Engine
    COS30019 - Introduction to Artificial Intelligence
    Swinburne University of Technology
    Alex Cummaudo <1744070@student.swin.edu.au>
    Semester 1, 2016

Download executable binary in an Oracle VirtualBox VM from here:

    http://link/tba/

To import the Virtual Machine, refer to the instructions here:

    https://docs.oracle.com/cd/E26217_01/E26796/html/qs-import-vm.html

Please refer to report.pdf for further details on the implementation.

Usage:

    iengine file method
    iengine --help

    Propositional logic inference engine

    File:
      Expects a file whose first line TELL's the knowledge base of its
      percepts and whose second line ASK's the knowledge base a query:

        TELL
        r; !u; p & !u => w
        ASK
        w

    Method:
      [TT] infer using truth table method
      [BC] infer using backward chaining method
      [FC] infer using forward chaining method
      [RE] infer using resolution method
