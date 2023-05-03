#Область ПрограммныйИнтерфейс

&После("НастроитьВариантыОтчетов")
Процедура бг_НастроитьВариантыОтчетов(Настройки) Экспорт
	
	// бг_АнализОтгружаемыхМарок
	ОписаниеОтчета = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.бг_АнализОтгружаемыхМарок);
	ОписаниеОтчета.ОпределитьНастройкиФормы = Истина;
	
	// бг_АнализПринимаемыхМарок
	ОписаниеОтчета = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.бг_АнализПринимаемыхМарок);
	ОписаниеОтчета.ОпределитьНастройкиФормы = Истина;
	
	// бг_АнализПриходуемыхМарок
	ОписаниеОтчета = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.бг_АнализПриходуемыхМарок);
	ОписаниеОтчета.ОпределитьНастройкиФормы = Истина;
	
	// бг_АнализСписываемыхМарок
	ОписаниеОтчета = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.бг_АнализСписываемыхМарок);
	ОписаниеОтчета.ОпределитьНастройкиФормы = Истина;
	
	// бг_ДвижениеМарок
	ОписаниеОтчета = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.бг_ДвижениеМарок);
	ОписаниеОтчета.ОпределитьНастройкиФормы = Истина;
	
	// бг_СоответствиеРасходаМатериаловВПроизводствеНормативам
	ОписаниеОтчета = ВариантыОтчетов.ОписаниеОтчета(
		Настройки,
		Метаданные.Отчеты.бг_СоответствиеРасходаМатериаловВПроизводствеНормативам);
	ОписаниеОтчета.ОпределитьНастройкиФормы = Истина;
	
	// бг_СостояниеМарок
	ОписаниеОтчета = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.бг_СостояниеМарок);
	ОписаниеОтчета.ОпределитьНастройкиФормы = Истина;
	
	// бг_СверкаЗаказаРозничногоПокупателя
	ОписаниеОтчета = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.бг_СверкаЗаказаРозничногоПокупателя);
	ОписаниеОтчета.ОпределитьНастройкиФормы = Истина;
	
	// бг_РасшифровкаСкидокЗаказаКлиента
	ОписаниеОтчета = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.бг_РасшифровкаСкидокЗаказаКлиента);
	ОписаниеОтчета.ОпределитьНастройкиФормы = Истина;
	
КонецПроцедуры

#КонецОбласти
