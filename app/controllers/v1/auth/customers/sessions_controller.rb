class V1::Auth::Customers::SessionsController < DeviseTokenAuth::SessionsController
    
    def create
        super
        # ログインした際に、フィーダバックされたものを検索する
        # まだトレーナーの評価を返していなかったら返すログイン時に返す
    end

    def destroy
        super
    end
end
