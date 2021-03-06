class OwnershipsController < ApplicationController
  def create
    @item = Item.find_or_initialize_by(isbn: params[:isbn])

    unless @item.persisted?
      results = RakutenWebService::Books::Book.search(isbn: @item.isbn)
      @item = Item.new(read(results.first))
      @item.save
    end
    
    if params[:type] == 'Have'
      current_user.have(@item)
      flash[:success] = '本棚に入れました'
    end
    
    if params[:type] == 'Want'
      current_user.want(@item)
      flash[:success] = '読みたい本に追加しました'
    end
    
    redirect_back(fallback_location: root_path)
    
  end
   
  def destroy
    @item = Item.find(params[:item_id])
    
    if params[:type] == 'Have'
      current_user.unhave(@item)
      flash[:success] = '本棚から取り出しました'
    end
    
    if params[:type] == 'Want'
      current_user.unwant(@item)
      flash[:success] = '読みたい本から削除しました'
    end
    
    redirect_back(fallback_location: root_path)
  end
end