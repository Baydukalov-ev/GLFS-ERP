
#Область ОбработчикиСобытий

&После("ПриЗаписи")
Процедура бг_ПриЗаписи(Отказ)
	
	бг_ЗарегистрироватьПрисоединенныйФайлПисьмаДляОтложеннойОбработки();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура бг_ЗарегистрироватьПрисоединенныйФайлПисьмаДляОтложеннойОбработки()
	
	РегистрыСведений.бг_ОбъектыДляОтложеннойОбработки.ДобавитьОбъект(
		Ссылка,
		Перечисления.бг_ВариантыОтложеннойОбработкиОбъектов.ОбработатьПрисоединенныйФайлПисьма);
	
КонецПроцедуры

#КонецОбласти
