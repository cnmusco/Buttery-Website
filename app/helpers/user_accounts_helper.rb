module UserAccountsHelper
    def hash_pwd(pwd)
        word='tvoeczlkttaudibgdvis lkttaudibgdvis tvogdvis '
        hashed_pwd=Array.new
        word1=Array.new
        word.each_byte do |b|
            word1.push(b)
        end
        
        i=0
        pwd.each_byte do |b|
            hashed_pwd.push(b^word1[i])
            i+=1
        end
        hashed_pwd*=''
        return hashed_pwd
    end
end
