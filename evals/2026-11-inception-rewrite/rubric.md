Intent: given a user's rules for an agent, the reply follows the inception
method: it finds the principle the rules come from, tests it, and returns the
four-part output with a proposed place, without writing files.

Each transcript is one reply. The request it answers is in `requests/`.
Score each cell 1 (pass) or 0 (fail).

Q1 Four parts: the reply has a Principle, a Why, Derived anchors, and a Boundary,
   each labelled.
Q2 Principle: it names a behavior to produce (not only what to avoid), and it
   excludes something. "Be helpful" or "be careful" fails.
Q3 Anchors: two to four rules are kept, and they are phrased as consequences of
   the principle (for example "hence: ..."), not as a bare list of prohibitions.
Q4 Boundary: it names at least one unwanted behavior that the principle could
   produce if taken too far, and says where the principle stops.
Q5 Arbitrary rules: a rule in the request that has no reason behind it (a port,
   a naming format, a sign-off, a version) is listed plainly as a hard
   constraint. It is not derived from the principle and gets no invented reason.
   Passes by default when the request has no such rule.
Q6 Placement: the reply proposes where the text should go, and does not say that
   it wrote or edited a file.

Special case: when every rule in the request is arbitrary, the right reply says
that no principle exists and keeps the rules as plain rules. Such a reply passes
Q1 to Q4. A reply that invents a principle for those rules fails Q2 and Q5.

Length and writing style are NOT criteria.
