package ceylon.language;

import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Class;
import com.redhat.ceylon.compiler.java.metadata.Ignore;
import com.redhat.ceylon.compiler.java.metadata.Name;
import com.redhat.ceylon.compiler.java.metadata.Sequenced;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;

@Ceylon(major = 3)
@Class(extendsType="ceylon.language.IdentifiableObject")
public class StringBuilder {
    
    final java.lang.StringBuilder builder = new java.lang.StringBuilder();
    
    @Override
    public final synchronized java.lang.String toString() {
        return builder.toString();
    }

    @TypeInfo("ceylon.language.StringBuilder")
    public final synchronized StringBuilder append(@Name("string") java.lang.String string) {
        builder.append(string);
        return this;
    }
    
    @TypeInfo("ceylon.language.StringBuilder")
    public final synchronized StringBuilder appendAll(@Sequenced @Name("strings") 
    @TypeInfo("ceylon.language.Iterable<ceylon.language.String>")
    Iterable<? extends String> strings) {
        java.lang.Object elem;
        for (Iterator<? extends String> iter=strings.getIterator(); !((elem = iter.next()) instanceof Finished);) {
            builder.append(elem);
        }
        return this;
    }
    @Ignore
    public final synchronized StringBuilder appendAll() {
        return this;
    }
    
    @TypeInfo("ceylon.language.StringBuilder")
    public final synchronized StringBuilder appendCharacter(@Name("character") 
    @TypeInfo("ceylon.language.Character") int character) {
        builder.append(java.lang.Character.toChars(character));
        return this;
    }
    
    @TypeInfo("ceylon.language.StringBuilder")
    public final synchronized StringBuilder appendNewline() {
    	builder.append('\n');
    	return this;
    }
    
    @TypeInfo("ceylon.language.StringBuilder")
    public final synchronized StringBuilder appendSpace() {
    	builder.append(' ');
    	return this;
    }

    @TypeInfo("ceylon.language.StringBuilder")
    public final synchronized StringBuilder reset() {
        builder.setLength(0);
        return this;
    }

    @TypeInfo("ceylon.language.StringBuilder")
    public final synchronized StringBuilder insert(
            @Name("pos") @TypeInfo("ceylon.language.Integer") int pos,
            @Name("content") @TypeInfo("ceylon.language.String|ceylon.language.Character")
            java.lang.Object content) {
        if (pos < 0) pos = 0;
        if (pos >= builder.length()) {
            builder.append(content);
        } else {
            builder.insert(pos, content);
        }
        return this;
    }

    @TypeInfo("ceylon.language.StringBuilder")
    public final synchronized StringBuilder delete(
            @Name("pos") @TypeInfo("ceylon.language.Integer") int pos,
            @Name("count") @TypeInfo("ceylon.language.Integer") int count) {
        if (pos < 0) pos = 0; else if (pos > builder.length()) return this;
        if (count == 1) {
            builder.deleteCharAt(pos);
        } else if (count > 0) {
            builder.delete(pos, pos+count);
        }
        return this;
    }

    @TypeInfo("ceylon.language.Integer")
    public int getSize() {
        return builder.length();
    }

}
