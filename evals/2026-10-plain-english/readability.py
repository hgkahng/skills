import re
def syllables(word):
    w=re.sub(r"[^a-z]","",word.lower())
    if not w: return 0
    n=len(re.findall(r"[aeiouy]+",w))
    if w.endswith("e") and not w.endswith(("le","ee","ye")) and n>1: n-=1
    if w.endswith(("es","ed")) and n>1 and not w.endswith(("ted","ded","ses","zes","ces","ges","xes")): n-=1
    return max(1,n)
def prose(t):
    t=re.sub(r"```.*?```"," ",t,flags=re.S); t=re.sub(r"`[^`]*`"," ",t)
    t=re.sub(r"^[#>*\-\s]+","",t,flags=re.M); return re.sub(r"\*\*|__","",t)
def stats(raw):
    t=prose(raw)
    sents=[s for s in re.split(r"(?<=[.?!])\s+|\n+",t) if len(re.findall(r"[A-Za-z]+",s))>=3]
    words=re.findall(r"[A-Za-z']+",t); ns=max(1,len(sents)); nw=max(1,len(words))
    syl=sum(syllables(w) for w in words)
    fk=0.39*nw/ns+11.8*syl/nw-15.59
    fre=206.835-1.015*nw/ns-84.6*syl/nw
    long3=sum(1 for w in words if syllables(w)>=3)
    return dict(fk=fk,fre=fre,msl=nw/ns,long=100*long3/nw,words=len(words))
if __name__=="__main__":
    for s in ["The cat sat on the mat. It was happy.","Notwithstanding considerable epistemological uncertainty, practitioners generally prefer parameterized approximations."]:
        print(round(stats(s)["fk"],1), s[:40])
