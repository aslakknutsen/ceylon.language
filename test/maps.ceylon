// tests for Map and Set interface
// Not much functionality to test here, as concrete interface members are not
// supported yet. But we can test if all members can be implemented, everything
// compiles, types are correct, etc.

interface SetTestBase<out Element> satisfies Set<Element>
            given Element satisfies Object {
    shared formal Element[] elements;
}

abstract class SetTest<Element>(Element... elements)
            satisfies SetTestBase<Element>
            given Element satisfies Object {
    shared actual Element[] elements = elements;
    shared actual Integer size { return elements.size; }
    shared actual Boolean empty { return elements.empty; }
    shared actual SetTest<Element> clone { return this; }
    shared actual Iterator<Element> iterator { return elements.iterator; }
    shared actual Integer hash { return elements.hash; }
    shared actual Boolean equals(Object other) {
        if (is SetTestBase<Object> other) {
            return other.elements == elements;
        }
        return false;
    }
    shared actual Boolean contains(Object element) {
        for (e in elements) {
            if (e == element) { return true; }
        }
        return false;
    }
    shared actual Boolean containsAny(Object... elems) {
        for (e in elems) {
            if (contains(e)) { return true; }
        }
        return false;
    }
    shared actual Boolean containsEvery(Object... elems) {
        for (e in elems) {
            if (!contains(e)) { return false; }
        }
        return true;
    }
    shared actual Integer count(Object element) {
        return contains(element) then 1 else 0;
    }
    shared actual Boolean superset(Set<Object> set) {
        for (e in set) {
            if (!contains(e)) { return false; }
        }
        return true;
    }
    shared actual Boolean subset(Set<Object> set) {
        for (e in elements) {
            if (!(e in set)) { return false; }
        }
        return true;
    }
    /*shared actual Set<Element|Other> union<Other>(Set<Other> set)
                given Other satisfies Object {
        return bottom; //TODO
    }
    shared actual Set<Element&Other> intersection<Other>(Set<Other> set)
                given Other satisfies Object {
        return bottom; //TODO
    }
    shared actual Set<Element|Other> exclusiveUnion<Other>(Set<Other> set)
                given Other satisfies Object {
        return bottom; //TODO
    }
    shared actual Set<Element> complement<Other>(Set<Other> set)
                given Other satisfies Object {
        return bottom; //TODO
    }*/
}

interface MapTestBase<out Key, out Item> satisfies Map<Key, Item>
            given Key satisfies Object
            given Item satisfies Object {
    shared formal Entry<Key, Item>[] entries;
}

class MapTest<Key, Item>(Key->Item... entries)
            satisfies MapTestBase<Key, Item>
            given Key satisfies Object
            given Item satisfies Object {
    shared actual Entry<Key, Item>[] entries = entries;
    shared actual Boolean equals(Object other) {
        if (is MapTestBase<Object, Object> other) {
            return other.entries == entries;
        }
        return false;
    }
    shared actual Integer hash { return entries.hash; }
    shared actual Integer size { return entries.size; }
    shared actual Boolean empty { return entries.empty; }
    shared actual MapTest<Key, Item> clone { return this; }
    shared actual Iterator<Key->Item> iterator { return entries.iterator; }
    shared actual Item? item(Object key) {
        for (e in entries) {
            if (e.key == key) { return e.item; }
        }
        return null;
    }
    shared actual Item?[] items(Object... keys) {
        value sb = SequenceBuilder<Item?>();
        for (k in keys) { sb.append(item(k)); }
        return sb.sequence;
    }
    shared actual Boolean defines(Object key) {
        for (e in entries) {
            if (e.key == key) { return true; }
        }
        return false;
    }
    shared actual Boolean definesAny(Object... keys) {
        for (k in keys) {
            if (defines(k)) { return true; }
        }
        return false;
    }
    shared actual Boolean definesEvery(Object... keys) {
        for (k in keys) {
            if (!defines(k)) { return false; }
        }
        return true;
    }
    shared actual Boolean contains(Object element) {
        if (is Object->Object element) {
            if (exists it = item(element.key)) { return it == element.item; }
        }
        return false;
    }
    shared actual Boolean containsAny(Object... element) {
        for (e in element) {
            if (contains(e)) { return true; }
        }
        return false;
    }
    shared actual Boolean containsEvery(Object... element) {
        for (e in element) {
            if (!contains(e)) { return false; }
        }
        return true;
    }
    shared actual Integer count(Object element) {
        return contains(element) then 1 else 0;
    }
    shared actual Set<Key> keys {
        value sb = SequenceBuilder<Key>();
        for (e in entries) { sb.append(e.key); }
        return bottom; //TODO: SetTest<Key>(sn.sequence...)
    }
    shared actual Collection<Item> values {
        value sb = SequenceBuilder<Item>();
        for (e in entries) { sb.append(e.item); }
        return array(sb.sequence...);
    }
    shared actual Map<Item, Set<Key>> inverse {
        value sb = SequenceBuilder<Item->Set<Key>>();
        variable Integer count := 0;
        for (e in entries) {
            value keySB = SequenceBuilder<Key>();
            variable Integer cnt2 := 0; 
            variable Boolean duplicate := false;
            for (e2 in entries) {
                if (e2.item == e.item) {
                    if (cnt2 < count) {
                        duplicate := true;
                        break;
                    }
                    keySB.append(e2.key);
                }
                ++cnt2;
            }
            if (!duplicate) {
                //TODO: sb.append(e.item->SetTest<Key>(keySB.sequence));
            }
            ++count;
        }
        return bottom; //TODO: TestSet<Key>(sb.sequence)
    }
}

void testMaps() {
    value m1 = MapTest<Integer, String>(1->"A", 2->"B", 3->"C", 4->"B");
    assert(m1.count(2->"B")==1, "Map.count 1");
    assert(m1.count(4.2)==0, "Map.count 2");
    assert(2->"B" in m1, "Map.contains 1");
    assert(!(4.2 in m1), "Map.contains 2");
    assert(!(1->"C" in m1), "Map.contains 3");
    assert(m1.clone == m1, "Map.clone/equals");
    assert(m1 != 5, "Map.equals");
    assert(m1.defines(4), "Map.defines 1");
    assert(!m1.defines(5), "Map.defines 2");
    assert(!m1.defines("hi"), "Map.defines 3");
    assert(exists m1[4], "Map.item 1");
    assert(!exists m1[5], "Map.item 2");
    assert(!exists m1["hi"], "Map.item 3");
    assert(!(is Finished m1.iterator.next()), "Map.iterator");
    assert(m1.values.size==m1.size, "Map.values 1");
    for (e in m1) {
        assert(e.item in m1.values, "Map.values 2");
    }
}