
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытий

&ИзменениеИКонтроль("ПередЗаписью")
Процедура бг_ПередЗаписью(Объект, Отказ, РежимЗаписи, РежимПроведения) Экспорт
#Удаление	
	Возврат;
#КонецУдаления
#Вставка
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Объект.бг_РегистрыДвижений.Очистить();
	КонецЕсли;
#КонецВставки	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
